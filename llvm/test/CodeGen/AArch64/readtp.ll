; RUN: llc -mtriple=arm64-none-linux-gnu -O2 -mattr=+read-tp-soft %s -o - | FileCheck %s -check-prefix=CHECK-SOFT
; RUN: llc -mtriple=arm64-none-linux-gnu -O2 %s -o - | FileCheck %s -check-prefix=CHECK-HARD


; __thread int counter;
;  void foo() {
;    counter = 5;
;  }


@counter = thread_local local_unnamed_addr global i32 0, align 4

define void @foo() local_unnamed_addr #0 {
entry:
  store i32 5, i32* @counter, align 4
  ret void
}


; CHECK-LABEL: foo:
; CHECK-SOFT:    bl	__aarch64_read_tp
; CHECK-HARD:    mrs	{{x[0-9]+}}, TPIDR_EL0

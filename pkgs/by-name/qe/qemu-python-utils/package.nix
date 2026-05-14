{ python3Packages }:
with python3Packages;
toPythonApplication (
  qemu.override {
    fuseSupport = true;
    tuiSupport = true;
  }
)

{ python3Packages }:
with python3Packages;
toPythonApplication (
  pyglossary.override {
    enableGui = true;
    enableCmd = true;
  }
)

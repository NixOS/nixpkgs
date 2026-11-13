{
  python3,
}:

python3.pkgs.toPythonApplication (
  python3.pkgs.pyglossary.override {
    enableGui = true;
    enableCmd = true;
  }
)

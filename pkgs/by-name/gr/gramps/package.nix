{
  python3Packages,
  enableOSM ? true,
  enableGraphviz ? true,
  enableGhostscript ? true,
}:

python3Packages.toPythonApplication (
  python3Packages.gramps.override {
    inherit enableOSM enableGraphviz enableGhostscript;
  }
)

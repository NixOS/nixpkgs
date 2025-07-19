{
  makeSetupHook,
  lcov,
  enableGCOVInstrumentation,
}:
makeSetupHook {
  name = "make-gcov-report-hook";
  propagatedBuildInputs = [
    lcov
    enableGCOVInstrumentation
  ];
} ./hook.sh

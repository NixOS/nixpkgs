{
  makeSetupHook,
  cmake,
}:

makeSetupHook {
  name = "ctestCheckHook";
  propagatedBuildInputs = [ cmake ];
} ./ctest-check-hook.sh

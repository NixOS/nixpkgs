{
  lib,
  makeSetupHook,
  cmake,
}:

makeSetupHook {
  name = "ctestCheckHook";
  propagatedBuildInputs = [ cmake ];
  meta.license = lib.licenses.mit;
} ./ctest-check-hook.sh

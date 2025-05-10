{
  callPackages,
  computeFrequencyMap,
  isDeclaredArray,
  lib,
  makeSetupHook,
  occursInArray,
}:
makeSetupHook {
  name = "arrayDifference";
  propagatedBuildInputs = [
    computeFrequencyMap
    isDeclaredArray
    occursInArray
  ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Computes the difference of two arrays";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./arrayDifference.bash

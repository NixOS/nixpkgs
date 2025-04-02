{
  callPackages,
  isDeclaredArray,
  isDeclaredMap,
  lib,
  makeSetupHook,
}:
makeSetupHook {
  name = "computeFrequencyMap";
  propagatedBuildInputs = [
    isDeclaredArray
    isDeclaredMap
  ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Computes the frequency of each element in an array";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./computeFrequencyMap.bash

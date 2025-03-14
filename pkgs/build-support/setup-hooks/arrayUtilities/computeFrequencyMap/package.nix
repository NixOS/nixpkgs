{
  callPackages,
  isDeclaredArray,
  isDeclaredMap,
  lib,
  makeSetupHook',
}:
makeSetupHook' {
  name = "computeFrequencyMap";
  script = ./computeFrequencyMap.bash;
  nativeBuildInputs = [
    isDeclaredArray
    isDeclaredMap
  ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Computes the frequency of each element in an array";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

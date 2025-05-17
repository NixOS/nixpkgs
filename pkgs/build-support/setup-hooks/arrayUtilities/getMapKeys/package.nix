{
  callPackages,
  isDeclaredArray,
  isDeclaredMap,
  lib,
  makeSetupHook,
  sortArray,
}:
makeSetupHook {
  name = "getMapKeys";
  propagatedBuildInputs = [
    isDeclaredArray
    isDeclaredMap
    sortArray
  ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Gets the sorted indices of an associative array";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./getMapKeys.bash

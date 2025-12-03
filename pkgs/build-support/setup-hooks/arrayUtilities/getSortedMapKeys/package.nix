{
  callPackages,
  isDeclaredArray,
  isDeclaredMap,
  makeSetupHook,
  sortArray,
}:
makeSetupHook {
  name = "getSortedMapKeys";
  propagatedBuildInputs = [
    isDeclaredArray
    isDeclaredMap
    sortArray
  ];
  passthru.tests = callPackages ./tests.nix { };
  meta.description = "Gets the sorted indices of an associative array";
} ./getSortedMapKeys.bash

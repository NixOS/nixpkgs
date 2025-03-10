{
  isDeclaredArray,
  isDeclaredMap,
  lib,
  makeSetupHook',
  sortArray,
}:
makeSetupHook' {
  name = "getMapKeys";
  script = ./getMapKeys.bash;
  nativeBuildInputs = [
    isDeclaredArray
    isDeclaredMap
    sortArray
  ];
  # TODO(@connorbaker): add tests
  # passthru.tests = callPackages ./tests.nix {};
  meta = {
    description = "Gets the indices of an associative array";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

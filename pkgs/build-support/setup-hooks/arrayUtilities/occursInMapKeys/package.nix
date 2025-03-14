{
  isDeclaredMap,
  getMapKeys,
  lib,
  makeSetupHook',
  occursInArray,
}:
makeSetupHook' {
  name = "occursInMapKeys";
  script = ./occursInMapKeys.bash;
  nativeBuildInputs = [
    isDeclaredMap
    getMapKeys
    occursInArray
  ];
  # TODO(@connorbaker): add tests
  # passthru.tests = callPackages ./tests.nix {};
  meta = {
    description = "Tests if a value occurs in the keys of a map";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

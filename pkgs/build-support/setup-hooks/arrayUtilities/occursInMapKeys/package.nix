{
  callPackages,
  isDeclaredMap,
  lib,
  makeSetupHook,
}:
makeSetupHook {
  name = "occursInMapKeys";
  propagatedBuildInputs = [ isDeclaredMap ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Tests if a value occurs in the keys of a map";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./occursInMapKeys.bash

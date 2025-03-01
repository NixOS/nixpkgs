{
  callPackages,
  lib,
  makeSetupHook,
}:
makeSetupHook {
  name = "isDeclaredMap";
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Tests if an associative array is declared";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./isDeclaredMap.bash

{
  lib,
  callPackages,
  makeSetupHook,
}:
makeSetupHook {
  name = "isDeclaredMap";
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Tests if an associative array is declared";
    license = lib.licenses.mit;
  };
} ./isDeclaredMap.bash

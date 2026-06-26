{
  lib,
  callPackages,
  makeSetupHook,
}:
makeSetupHook {
  name = "isDeclaredArray";
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Tests if an array is declared";
    license = lib.licenses.mit;
  };
} ./isDeclaredArray.bash

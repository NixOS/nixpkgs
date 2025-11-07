{
  callPackages,
  makeSetupHook,
}:
makeSetupHook {
  name = "isDeclaredArray";
  passthru.tests = callPackages ./tests.nix { };
  meta.description = "Tests if an array is declared";
} ./isDeclaredArray.bash

{
  callPackages,
  isDeclaredArray,
  lib,
  makeSetupHook,
}:
makeSetupHook {
  name = "occursInArray";
  propagatedBuildInputs = [ isDeclaredArray ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Tests if an element occurs in an array";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./occursInArray.bash

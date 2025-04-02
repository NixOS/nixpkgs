{
  callPackages,
  isDeclaredArray,
  lib,
  makeSetupHook,
}:
makeSetupHook {
  name = "occursOnlyOrAfterInArray";
  propagatedBuildInputs = [ isDeclaredArray ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Tests if an element occurs only or after a given element in an array";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./occursOnlyOrAfterInArray.bash

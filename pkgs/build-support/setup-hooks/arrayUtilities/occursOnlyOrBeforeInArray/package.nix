{
  callPackages,
  isDeclaredArray,
  lib,
  makeSetupHook,
}:
makeSetupHook {
  name = "occursOnlyOrBeforeInArray";
  propagatedBuildInputs = [ isDeclaredArray ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Tests if an element occurs only or before a given index in an array";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./occursOnlyOrBeforeInArray.bash

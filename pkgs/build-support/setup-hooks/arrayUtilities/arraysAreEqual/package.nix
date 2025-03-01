{
  callPackages,
  isDeclaredArray,
  lib,
  makeSetupHook,
}:
makeSetupHook {
  name = "arraysAreEqual";
  propagatedBuildInputs = [ isDeclaredArray ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Tests if two arrays are equal";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./arraysAreEqual.bash

{
  callPackages,
  isDeclaredArray,
  lib,
  makeSetupHook,
}:
makeSetupHook {
  name = "sortArray";
  propagatedBuildInputs = [ isDeclaredArray ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Sorts an array";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./sortArray.bash

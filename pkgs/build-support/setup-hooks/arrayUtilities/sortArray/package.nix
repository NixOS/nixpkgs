{
  lib,
  callPackages,
  isDeclaredArray,
  makeSetupHook,
}:
makeSetupHook {
  name = "sortArray";
  propagatedBuildInputs = [ isDeclaredArray ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Sorts an array";
    license = lib.licenses.mit;
  };
} ./sortArray.bash

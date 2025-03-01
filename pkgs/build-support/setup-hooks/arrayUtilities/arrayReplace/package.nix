{
  callPackages,
  lib,
  makeSetupHook,
  isDeclaredArray,
  isDeclaredMap,
  occursInMapKeys,
}:
makeSetupHook {
  name = "arrayReplace";
  propagatedBuildInputs = [
    isDeclaredArray
    isDeclaredMap
    occursInMapKeys
  ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Replaces all occurrences of a value in an array with other value(s)";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./arrayReplace.bash

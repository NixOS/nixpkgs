{
  callPackages,
  isDeclaredArray,
  lib,
  makeSetupHook,
  patchelf,
}:
makeSetupHook {
  name = "getRunpathEntries";
  propagatedBuildInputs = [
    isDeclaredArray
    patchelf
  ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Populates a reference to an array with the runpath entries of a given file";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./getRunpathEntries.bash

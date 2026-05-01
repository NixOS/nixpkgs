{
  callPackages,
  isDeclaredArray,
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
  meta.description = "Appends runpath entries of a file to an array";
} ./getRunpathEntries.bash

{
  callPackages,
  isDeclaredArray,
  lib,
  makeSetupHook,
  patchelf,
}:
makeSetupHook {
  name = "getElfFiles";
  propagatedBuildInputs = [
    isDeclaredArray
    patchelf
  ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Populates a reference to an array with paths to ELF files in given paths";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./getElfFiles.bash

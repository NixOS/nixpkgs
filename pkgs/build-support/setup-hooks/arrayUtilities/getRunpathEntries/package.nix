{
  isDeclaredArray,
  lib,
  makeSetupHook',
  patchelf,
}:
makeSetupHook' {
  name = "getRunpathEntries";
  script = ./getRunpathEntries.bash;
  nativeBuildInputs = [
    isDeclaredArray
    patchelf
  ];
  # TODO(@connorbaker): add tests
  # passthru.tests = callPackages ./tests.nix {};
  meta = {
    description = "Populates a reference to an array with the runpath entries of a given file";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

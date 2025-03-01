{
  isDeclaredArray,
  lib,
  makeSetupHook',
  patchelf,
}:
makeSetupHook' {
  name = "getElfFiles";
  script = ./getElfFiles.bash;
  nativeBuildInputs = [
    isDeclaredArray
    patchelf
  ];
  # TODO(@connorbaker): add tests
  # passthru.tests = callPackages ./tests.nix {};
  meta = {
    description = "Populates a reference to an array with paths to ELF files in a given directory";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

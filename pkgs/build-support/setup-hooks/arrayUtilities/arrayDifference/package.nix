{
  callPackages,
  isDeclaredArray,
  lib,
  makeSetupHook',
  occursInArray,
}:
makeSetupHook' {
  name = "arrayDifference";
  script = ./arrayDifference.bash;
  nativeBuildInputs = [
    isDeclaredArray
    occursInArray
  ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Computes the difference of two arrays";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

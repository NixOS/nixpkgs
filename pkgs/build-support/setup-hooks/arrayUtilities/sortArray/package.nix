{
  callPackages,
  isDeclaredArray,
  lib,
  makeSetupHook',
}:
makeSetupHook' {
  name = "sortArray";
  script = ./sortArray.bash;
  nativeBuildInputs = [ isDeclaredArray ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Sorts an array";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

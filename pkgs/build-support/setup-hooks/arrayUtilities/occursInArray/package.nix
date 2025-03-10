{
  isDeclaredArray,
  lib,
  makeSetupHook',
}:
makeSetupHook' {
  name = "occursInArray";
  script = ./occursInArray.bash;
  nativeBuildInputs = [ isDeclaredArray ];
  # TODO(@connorbaker): Add tests
  # passthru.tests = callPackages ./tests.nix {};
  meta = {
    description = "Tests if an element occurs in an array";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

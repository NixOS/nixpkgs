{
  isDeclaredArray,
  lib,
  makeSetupHook',
}:
makeSetupHook' {
  name = "occursOnlyOrAfterInArray";
  script = ./occursOnlyOrAfterInArray.bash;
  nativeBuildInputs = [ isDeclaredArray ];
  # TODO(@connorbaker): add tests
  # passthru.tests = callPackages ./tests.nix {};
  meta = {
    description = "Tests if an element occurs only or after a given element in an array";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

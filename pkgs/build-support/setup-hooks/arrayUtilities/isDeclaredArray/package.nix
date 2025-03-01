{
  lib,
  makeSetupHook',
}:
makeSetupHook' {
  name = "isDeclaredArray";
  script = ./isDeclaredArray.bash;
  # TODO(@connorbaker): Add tests
  # passthru.tests = callPackages ./tests.nix {};
  meta = {
    description = "Tests if an array is declared";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

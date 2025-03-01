{
  lib,
  makeSetupHook',
}:
makeSetupHook' {
  name = "isDeclaredMap";
  script = ./isDeclaredMap.bash;
  # TODO(@connorbaker): add tests
  # passthru.tests = callPackages ./tests.nix {};
  meta = {
    description = "Tests if an associative array is declared";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

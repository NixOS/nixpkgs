{
  isDeclaredMap,
  lib,
  makeSetupHook',
}:
makeSetupHook' {
  name = "mapIsSubmap";
  script = ./mapIsSubmap.bash;
  nativeBuildInputs = [ isDeclaredMap ];
  # TODO(@connorbaker): add tests
  # passthru.tests = callPackages ./tests.nix {};
  meta = {
    description = "Tests if a map is a submap of another map";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

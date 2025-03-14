{
  isDeclaredMap,
  lib,
  makeSetupHook',
  mapIsSubmap,
}:
makeSetupHook' {
  name = "mapsAreEqual";
  script = ./mapsAreEqual.bash;
  nativeBuildInputs = [
    isDeclaredMap
    mapIsSubmap
  ];
  # TODO(@connorbaker): add tests
  # passthru.tests = callPackages ./tests.nix {};
  meta = {
    description = "Tests if two maps are equal";
    maintainers = [ lib.maintainers.connorbaker ];
  };
}

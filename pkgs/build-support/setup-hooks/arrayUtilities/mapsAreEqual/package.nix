{
  callPackages,
  isDeclaredMap,
  lib,
  makeSetupHook,
  mapIsSubmap,
}:
makeSetupHook {
  name = "mapsAreEqual";
  propagatedBuildInputs = [
    isDeclaredMap
    mapIsSubmap
  ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Tests if two maps are equal";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./mapsAreEqual.bash

{
  callPackages,
  isDeclaredMap,
  lib,
  makeSetupHook,
  occursInMapKeys,
}:
makeSetupHook {
  name = "mapIsSubmap";
  propagatedBuildInputs = [
    isDeclaredMap
    occursInMapKeys
  ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Tests if a map is a submap of another map";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./mapIsSubmap.bash

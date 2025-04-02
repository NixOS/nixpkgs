{
  callPackages,
  isDeclaredMap,
  lib,
  makeSetupHook,
}:
makeSetupHook {
  name = "mapIsSubmap";
  propagatedBuildInputs = [ isDeclaredMap ];
  passthru.tests = callPackages ./tests.nix { };
  meta = {
    description = "Tests if a map is a submap of another map";
    maintainers = [ lib.maintainers.connorbaker ];
  };
} ./mapIsSubmap.bash

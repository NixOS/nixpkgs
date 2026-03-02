{
  makeSetupHook,
  lib,
  callPackage,
}:
makeSetupHook {
  name = "projucer-hook";
  propagatedBuildInputs = [ (callPackage ./package.nix { }) ];
  meta.platforms = lib.platforms.linux;
} ./projucer-hook.sh

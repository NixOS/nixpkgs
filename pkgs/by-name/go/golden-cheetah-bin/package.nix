{
  lib,
  stdenv,
  callPackage,
}:

let
  pname = "golden-cheetah";
  version = "3.7";

  commonMeta = {
    description = "Performance software for cyclists, runners and triathletes. This version includes the API Tokens for e.g. Strava";
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    maintainers = with lib.maintainers; [
      gador
      adamcstephens
    ];
    license = lib.licenses.gpl2Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
in

if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix {
    inherit
      stdenv
      pname
      commonMeta
      version
      ;
  }
else
  callPackage ./linux.nix { inherit pname commonMeta version; }

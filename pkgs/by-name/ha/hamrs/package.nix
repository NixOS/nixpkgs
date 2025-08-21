{
  lib,
  stdenvNoCC,
  callPackage,
}:

let
  pname = "hamrs";
  version = "1.0.7";

  meta = {
    description = "Simple, portable logger tailored for activities like Parks on the Air, Field Day, and more";
    homepage = "https://hamrs.app/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      ethancedwards8
      jhollowe
    ];
    platforms = [
      "aarch64-linux"
      "x86_64-linux"
      "i686-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "hamrs";
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
in
if stdenvNoCC.hostPlatform.isDarwin then
  callPackage ./darwin.nix { inherit pname version meta; }
else
  callPackage ./linux.nix { inherit pname version meta; }

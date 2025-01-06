{
  stdenvNoCC,
  callPackage,
  lib,
}:

let
  pname = "postman";
  version = "11.1.0";
  meta = {
    homepage = "https://www.getpostman.com";
    description = "API Development Environment";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.postman;
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    maintainers = with lib.maintainers; [
      johnrichardrinehart
      evanjs
      tricktron
      Crafter
    ];
  };

in

if stdenvNoCC.hostPlatform.isDarwin then
  callPackage ./darwin.nix { inherit pname version meta; }
else
  callPackage ./linux.nix { inherit pname version meta; }

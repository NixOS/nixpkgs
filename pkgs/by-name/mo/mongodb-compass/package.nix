{
  stdenv,
  callPackage,
  lib,
}:

let
  pname = "mongodb-compass";
  version = "1.46.0";
  meta = {
    description = "GUI for MongoDB";
    maintainers = with lib.maintainers; [
      bryanasdev000
      friedow
      iamanaws
    ];
    homepage = "https://github.com/mongodb-js/compass";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.sspl;
    platforms = [
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-darwin"
    ];
    mainProgram = "mongodb-compass";
  };
in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix { inherit pname version meta; }
else
  callPackage ./linux.nix { inherit pname version meta; }

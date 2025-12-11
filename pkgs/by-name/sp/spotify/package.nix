{
  lib,
  stdenv,
  callPackage,
  ...
}@args:

let
  extraArgs = removeAttrs args [ "callPackage" ];

  pname = "spotify";

  updateScript = ./update.sh;

  meta = {
    homepage = "https://www.spotify.com/";
    description = "Play music from the Spotify music service";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    license = lib.licenses.unfree;
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
    mainProgram = "spotify";
  };

in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix (extraArgs // { inherit pname updateScript meta; })
else
  callPackage ./linux.nix (extraArgs // { inherit pname updateScript meta; })

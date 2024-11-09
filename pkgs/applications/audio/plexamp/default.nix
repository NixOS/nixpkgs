{
  lib,
  stdenv,
  fetchurl,
  appimageTools,
  makeWrapper,
  callPackage,
  ...
}@args:

let
  pname = "plexamp";
  version = "4.11.2";
  extraArgs = removeAttrs args [ "callPackage" ];

  meta = with lib; {
    description = "Beautiful Plex music player for audiophiles, curators, and hipsters";
    homepage = "https://plexamp.com/";
    changelog = "https://forums.plex.tv/t/plexamp-release-notes/221280/76";
    license = licenses.unfree;
    maintainers = with maintainers; [
      killercup
      redhawk
      synthetica
    ];
    platforms = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };

in
if stdenv.hostPlatform.isDarwin then
  callPackage ./darwin.nix (
    removeAttrs extraArgs [
      "appimageTools"
      "makeWrapper"
    ]
    // {
      inherit pname version meta;
    }
  )
else
  callPackage ./linux.nix (
    removeAttrs extraArgs [
      "lib"
      "stdenv"
    ]
    // {
      inherit pname version meta;
    }
  )

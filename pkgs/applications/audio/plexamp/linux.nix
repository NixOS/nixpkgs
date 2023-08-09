{ lib, fetchurl, appimageTools, pkgs, pname, version, meta }:

let
  inherit pname version meta;
  src = fetchurl {
    url = "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${version}.AppImage";
    sha256 = "sha256-L0088wEhLIWwEB01E85tChRjW4zykYZSsVbLvsvcYHI=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src meta;

  multiArch = false; # no 32bit needed

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/plexamp.desktop $out/share/applications/plexamp.desktop
    install -m 444 -D ${appimageContents}/plexamp.png \
      $out/share/icons/hicolor/512x512/apps/plexamp.png
    substituteInPlace $out/share/applications/plexamp.desktop \
      --replace 'Exec=AppRun' 'Exec=plexamp-${version}'
  '';
}

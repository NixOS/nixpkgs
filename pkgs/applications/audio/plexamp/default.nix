{ lib, fetchurl, appimageTools, pkgs }:

let
  pname = "plexamp";
  version = "3.2.0";
  name = "${pname}-${version}";

  src = fetchurl {
    url = "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${version}.AppImage";
    sha256 = "R1BhobnwoU7oJ7bNes8kH2neXqHlMPbRCNjcHyzUPqo=";
    name="${pname}-${version}.AppImage";
  };

  appimageContents = appimageTools.extractType2 {
    inherit name src;
  };
in appimageTools.wrapType2 {
  inherit name src;

  multiPkgs = null; # no 32bit needed
  extraPkgs = pkgs: appimageTools.defaultFhsEnvArgs.multiPkgs pkgs ++ [ pkgs.bash ];

  extraInstallCommands = ''
    ln -s $out/bin/${name} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/plexamp.desktop $out/share/applications/plexamp.desktop
    install -m 444 -D ${appimageContents}/plexamp.png \
      $out/share/icons/hicolor/512x512/apps/plexamp.png
    substituteInPlace $out/share/applications/plexamp.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "A beautiful Plex music player for audiophiles, curators, and hipsters.";
    homepage = "https://plexamp.com/";
    license = licenses.unfree;
    maintainers = with maintainers; [ killercup ];
    platforms = [ "x86_64-linux" ];
  };
}

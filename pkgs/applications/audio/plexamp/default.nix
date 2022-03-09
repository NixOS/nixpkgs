{ lib, fetchurl, appimageTools, pkgs }:

let
  pname = "plexamp";
  version = "4.0.3";

  src = fetchurl {
    url = "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${version}.AppImage";
    name="${pname}-${version}.AppImage";
    sha512 = "Nh0+/ibZnjcGXgQUe+QvukWpaX6/0nNPR4NIK0i2Bn6kBkihv9bkfF9xGpgqeE6H3CK+4e6ywg8y9RR+pJBBSA==";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in appimageTools.wrapType2 {
  inherit pname version src;

  multiPkgs = null; # no 32bit needed
  extraPkgs = pkgs: appimageTools.defaultFhsEnvArgs.multiPkgs pkgs ++ [ pkgs.bash ];

  extraInstallCommands = ''
    ln -s $out/bin/${pname}-${version} $out/bin/${pname}
    install -m 444 -D ${appimageContents}/plexamp.desktop $out/share/applications/plexamp.desktop
    install -m 444 -D ${appimageContents}/plexamp.png \
      $out/share/icons/hicolor/512x512/apps/plexamp.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  passthru.updateScript = ./update-plexamp.sh;

  meta = with lib; {
    description = "A beautiful Plex music player for audiophiles, curators, and hipsters";
    homepage = "https://plexamp.com/";
    changelog = "https://forums.plex.tv/t/plexamp-release-notes/221280/41";
    license = licenses.unfree;
    maintainers = with maintainers; [ killercup synthetica ];
    platforms = [ "x86_64-linux" ];
  };
}

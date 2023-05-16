{ lib, fetchurl, appimageTools, pkgs }:

let
  pname = "plexamp";
<<<<<<< HEAD
  version = "4.8.2";
=======
  version = "4.6.2";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchurl {
    url = "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${version}.AppImage";
    name="${pname}-${version}.AppImage";
<<<<<<< HEAD
    sha512 = "7NQmH42yzItReQ5WPdcbNPr/xed74H4UyDNlX5PGmoJRBpV1RdeuW1KRweIWfYNhw0KeqULVTjr/aCggoWp4WA==";
=======
    sha512 = "xGmE/ikL3ez0WTJKiOIcB5QtI7Ta9wq1Qedy9albWVpCS04FTnxQH5S0esTXw6j+iDTD8Lc2JbOhw8tYo/zRXg==";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in appimageTools.wrapType2 {
  inherit pname version src;

<<<<<<< HEAD
  multiArch = false; # no 32bit needed
=======
  multiPkgs = null; # no 32bit needed
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://forums.plex.tv/t/plexamp-release-notes/221280/52";
=======
    changelog = "https://forums.plex.tv/t/plexamp-release-notes/221280/49";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.unfree;
    maintainers = with maintainers; [ killercup synthetica ];
    platforms = [ "x86_64-linux" ];
  };
}

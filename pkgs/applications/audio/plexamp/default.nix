{ lib, fetchurl, appimageTools }:

let
  pname = "plexamp";
  version = "4.10.1";

  src = fetchurl {
    url = "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    hash = "sha512-Y43W6aPnZEMnkBQwSHbT8PWjuhkfNxce79Y9cixEPnq4VybROHGb9s6ghV7kP81TSWkb9QruFhmXfuJRSkXxTw==";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/plexamp.desktop $out/share/applications/plexamp.desktop
    install -m 444 -D ${appimageContents}/plexamp.svg \
      $out/share/icons/hicolor/scalable/apps/plexamp.svg
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  passthru.updateScript = ./update-plexamp.sh;

  meta = with lib; {
    description = "A beautiful Plex music player for audiophiles, curators, and hipsters";
    homepage = "https://plexamp.com/";
    changelog = "https://forums.plex.tv/t/plexamp-release-notes/221280/73";
    license = licenses.unfree;
    maintainers = with maintainers; [ killercup redhawk synthetica ];
    platforms = [ "x86_64-linux" ];
  };
}

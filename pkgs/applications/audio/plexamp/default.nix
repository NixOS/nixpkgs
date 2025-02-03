{ lib, fetchurl, appimageTools }:

let
  pname = "plexamp";
  version = "4.11.0";

  src = fetchurl {
    url = "https://plexamp.plex.tv/plexamp.plex.tv/desktop/Plexamp-${version}.AppImage";
    name = "${pname}-${version}.AppImage";
    hash = "sha512-t5ImqZvwKrZoobXFHX8wfQBQBPnAp4rJq4p1GLG/6CxAeKYuYMTPr7+xjwVqhGm/DGw7vSVY9sdMyFodq8rJ2A==";
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
    description = "Beautiful Plex music player for audiophiles, curators, and hipsters";
    homepage = "https://plexamp.com/";
    changelog = "https://forums.plex.tv/t/plexamp-release-notes/221280/74";
    license = licenses.unfree;
    maintainers = with maintainers; [ killercup redhawk synthetica ];
    platforms = [ "x86_64-linux" ];
  };
}

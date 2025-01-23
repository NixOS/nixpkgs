{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "badlion-client";
  version = "4.3.0";

  src = fetchurl {
    name = "badlion-client-linux";
    # https://www.badlion.net/download/client/latest/linux
    url = "https://web.archive.org/web/20240529090437if_/https://client-updates-cdn77.badlion.net/BadlionClient";
    hash = "sha256-9elNLSqCO21m1T2D+WABKotD9FfW3FrcOxbnPdyVd+w=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/BadlionClient.desktop $out/share/applications/BadlionClient.desktop
    install -Dm444 ${appimageContents}/BadlionClient.png $out/share/pixmaps/BadlionClient.png
    substituteInPlace $out/share/applications/BadlionClient.desktop \
      --replace 'Exec=AppRun --no-sandbox %U' 'Exec=badlion-client'
  '';

  meta = with lib; {
    description = "Most Complete All-In-One Mod Library for Minecraft with 100+ Mods, FPS Improvements, and more";
    homepage = "https://client.badlion.net";
    license = with licenses; [ unfree ];
    maintainers = [ ];
    mainProgram = "badlion-client";
    platforms = [ "x86_64-linux" ];
  };
}

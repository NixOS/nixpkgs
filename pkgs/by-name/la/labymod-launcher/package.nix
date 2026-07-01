{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "labymod-launcher";
  version = "3.0.10";

  src = fetchurl {
    name = "labymod-launcher";
    url = "https://releases.r2.labymod.net/launcher/linux/x64/LabyMod%20Launcher-${version}.AppImage";
    hash = "sha256-etrP2kfhaWVyTgRAsw8MeBy3ndScTkKi3ogXiaQZ2g0=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/labymodlauncher.desktop $out/share/applications/labymod-launcher.desktop
    install -Dm444 ${appimageContents}/resources/icons/icon.png $out/share/icons/hicolor/512x512/apps/labymod-launcher.png
    substituteInPlace $out/share/applications/labymod-launcher.desktop \
      --replace-fail 'Exec=labymodlauncher' 'Exec=labymod-launcher' \
      --replace-fail 'Icon=labymodlauncher' 'Icon=labymod-launcher'
  '';

  meta = {
    description = "Minecraft modification that enhances gameplay with features like in-game TeamSpeak integration, custom animations, and additional settings";
    homepage = "https://www.labymod.net/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ httprafa ];
    mainProgram = "labymod-launcher";
    platforms = [ "x86_64-linux" ];
  };
}

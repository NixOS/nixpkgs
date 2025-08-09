{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "labymod-launcher";
  version = "2.1.12";

  src = fetchurl {
    name = "labymod-launcher";
    url = "https://releases.r2.labymod.net/launcher/linux/x64/LabyMod%20Launcher-${version}.AppImage";
    hash = "sha256-n0ipNxtmVSG/Do5UcFpWhGH+4SO3ZljsUXPW4hYzkZU=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/labymodlauncher.desktop $out/share/applications/labymod-launcher.desktop
    install -Dm444 ${appimageContents}/resources/icons/icon.png $out/share/pixmaps/labymod-launcher.png
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

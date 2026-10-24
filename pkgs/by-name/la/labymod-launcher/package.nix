{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "labymod-launcher";
  version = "3.0.14";
  src = fetchurl {
    name = "labymod-launcher";
    url = "https://releases.r2.labymod.net/launcher/linux/x64/LabyMod%20Launcher-${finalAttrs.version}.AppImage";
    hash = "sha256-+NEO4Z8/g54o11YtCFzvNTWHcOTDZyBAQvEcpNg9/Nw=";
  };

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.contents}/labymodlauncher.desktop $out/share/applications/labymod-launcher.desktop
    install -Dm444 ${finalAttrs.contents}/resources/icons/icon.png $out/share/icons/hicolor/512x512/apps/labymod-launcher.png
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
})

{
  appimageTools,
  fetchurl,
  lib,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "artix-games-launcher";
  version = "2.20";

  src = fetchurl {
    url = "https://web.archive.org/web/20250924101414/https://launch.artix.com/latest/Artix_Games_Launcher-x86_64.AppImage";
    hash = "sha256-8eVXOm5g92wErWa6lbTXrCL04MWYlObjonHJk+oUI3E=";
  };

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    install -m 444 -D ${finalAttrs.contents}/ArtixGamesLauncher.desktop $out/share/applications/ArtixGamesLauncher.desktop
    install -m 444 -D ${finalAttrs.contents}/ArtixLogo.png $out/share/icons/ArtixLogo.png
    substituteInPlace $out/share/applications/ArtixGamesLauncher.desktop --replace-fail 'Exec=ArtixGameLauncher %u' 'Exec=artix-games-launcher %u'
  '';

  meta = {
    description = "Launcher for games by Artix Entertainment";
    homepage = "https://www.artix.com/downloads/artixlauncher";
    license = lib.licenses.unfree;
    mainProgram = "artix-games-launcher";
    maintainers = with lib.maintainers; [ jtliang24 ];
    platforms = [ "x86_64-linux" ];
  };
})

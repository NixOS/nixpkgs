{
  appimageTools,
  stdenv,
  fetchurl,
  lib,
}:
let
  pname = "artix-games-launcher";
  version = "2.20";
  src = fetchurl {
    url = "https://launch.artix.com/latest/Artix_Games_Launcher-x86_64.AppImage";
    hash = "sha256-8eVXOm5g92wErWa6lbTXrCL04MWYlObjonHJk+oUI3E=";
  };
  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
appimageTools.wrapType2 {
  inherit pname version src;

  meta = {
    description = "Launcher for games by Artix Entertainment";
    homepage = "https://www.artix.com/downloads/artixlauncher";
    license = lib.licenses.unfree;
    mainProgram = "artix-game-launcher";
    maintainers = with lib.maintainers; [ jtliang24 ];
    platforms = with lib.platforms; [ "x86_64-linux" ];
  };

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    install -m 444 -D ${appimageContents}/ArtixGamesLauncher.desktop $out/share/applications/ArtixGamesLauncher.desktop
    install -m 444 -D ${appimageContents}/ArtixLogo.png $out/share/icons/ArtixLogo.png
  '';

}

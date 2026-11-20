{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "steam-rom-manager";
  version = "2.6.3";

  src = fetchurl {
    url = "https://github.com/SteamGridDB/steam-rom-manager/releases/download/v${finalAttrs.version}/Steam-ROM-Manager-${finalAttrs.version}.AppImage";
    hash = "sha256-MUuP5q+0rX3NBsZrZVDCdx33/OdFk7+vSM5rGCnGegg=";
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/steam-rom-manager.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/steam-rom-manager.desktop \
      --replace 'Exec=AppRun' 'Exec=steam-rom-manager'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';

  meta = {
    description = "App for managing ROMs in Steam";
    homepage = "https://github.com/SteamGridDB/steam-rom-manager";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ squarepear ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "steam-rom-manager";
  };
})

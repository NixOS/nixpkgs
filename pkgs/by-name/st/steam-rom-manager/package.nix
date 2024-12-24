{ lib, appimageTools, fetchurl }:

appimageTools.wrapType2 rec {
  pname = "steam-rom-manager";
  version = "2.5.29";

  src = fetchurl {
    url = "https://github.com/SteamGridDB/steam-rom-manager/releases/download/v${version}/Steam-ROM-Manager-${version}.AppImage";
    sha256 = "sha256-6ZJ+MGIgr2osuQuqD6N9NnPiJFNq/HW6ivG8tyXUhvs=";
  };

  extraInstallCommands = let
    appimageContents = appimageTools.extract { inherit pname version src; };
    in ''
      install -m 444 -D ${appimageContents}/steam-rom-manager.desktop -t $out/share/applications
      substituteInPlace $out/share/applications/steam-rom-manager.desktop \
        --replace 'Exec=AppRun' 'Exec=steam-rom-manager'
      cp -r ${appimageContents}/usr/share/icons $out/share
    '';

  meta = with lib; {
    description = "App for managing ROMs in Steam";
    homepage = "https://github.com/SteamGridDB/steam-rom-manager";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ squarepear ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "steam-rom-manager";
  };
}

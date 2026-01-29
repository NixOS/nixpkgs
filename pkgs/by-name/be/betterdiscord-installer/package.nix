{
  appimageTools,
  lib,
  fetchurl,
  nix-update-script,
}:
let
  pname = "betterdiscord-installer";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/BetterDiscord/Installer/releases/download/v${version}/Betterdiscord-Linux.AppImage";
    hash = "sha256-In5J6TWoJsFODDwMXd1lMg3341IZJD2OJebVtgISxP0=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/betterdiscord-installer.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/betterdiscord-installer.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Installer for BetterDiscord";
    homepage = "https://betterdiscord.app";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "betterdiscord-installer";
  };
}

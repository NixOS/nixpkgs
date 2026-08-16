{
  appimageTools,
  lib,
  fetchurl,
  nix-update-script,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "betterdiscord-installer";
  version = "1.3.0";

  src = fetchurl {
    url = "https://github.com/BetterDiscord/Installer/releases/download/v${finalAttrs.version}/Betterdiscord-Linux.AppImage";
    hash = "sha256-In5J6TWoJsFODDwMXd1lMg3341IZJD2OJebVtgISxP0=";
  };

  extraPkgs = pkgs: [ pkgs.libxshmfence ];

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/betterdiscord-installer.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/betterdiscord-installer.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=betterdiscord-installer'
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Installer for BetterDiscord";
    homepage = "https://betterdiscord.app";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "betterdiscord-installer";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
})

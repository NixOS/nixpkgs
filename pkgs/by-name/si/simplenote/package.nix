{
  appimageTools,
  lib,
  fetchurl,
  nix-update-script,
  makeDesktopItem,
}:

let
  pname = "simplenote";
  version = "2.23.2";

  src = fetchurl {
    url = "https://github.com/Automattic/simplenote-electron/releases/download/v${version}/Simplenote-linux-${version}-x86_64.AppImage";
    hash = "sha512-m2Z1XlIdnxMgnHu6YWKZAp4Nwe1UaOyodtiKhy4/xvPwU2c8z4iBQHjgPoeAwnWJNQ/9JazPgBoP7W5oIMHLCg==";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/${pname}.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${pname}'

    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  extraPkgs =
    pkgs: with pkgs; [
      libsecret
      libnotify
      libappindicator-gtk3
    ];

  desktopItems = [
    makeDesktopItem
    {
      name = pname;
      exec = pname;
      icon = "simplenote";
      description = "The simplest way to keep notes";
    }
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "The simplest way to keep notes";
    homepage = "https://github.com/Automattic/simplenote-electron";
    license = lib.licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with lib.maintainers; [ josephfinlayson ];
    changelog = "https://github.com/Automattic/simplenote-electron/releases/tag/v${version}/RELEASE-NOTES.md";
  };
}

{
  appimageTools,
  lib,
  fetchurl,
  nix-update-script,
  makeDesktopItem,
}:

let
  pname = "simplenote";
  version = "2.22.2";

  src = fetchurl {
    url = "https://github.com/Automattic/simplenote-electron/releases/download/v${version}/Simplenote-linux-${version}-x86_64.AppImage";
    sha512 = "4aTMCbnURlJqgZqSqU/b3HTaWDp3FzFhWcES1ANxElNumfUs7IBdCGroyiumBUbQQb+4NG+Yj0kCKuVBjVXZXQ==";
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

  meta = with lib; {
    description = "The simplest way to keep notes";
    homepage = "https://github.com/Automattic/simplenote-electron";
    license = licenses.gpl2Plus;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ josephfinlayson ];
  };
}

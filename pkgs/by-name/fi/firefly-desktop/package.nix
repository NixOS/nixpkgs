{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "firefly-desktop";
  version = "2.1.8";
  src = fetchurl {
    url = "https://github.com/iotaledger/firefly/releases/download/desktop-${version}/firefly-desktop-${version}.AppImage";
    sha256 = "sha256-MATMl5eEIauDQpz8/wqIzD7IugPVZ2HJAWCbDM4n+hA=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    install -D ${appimageContents}/desktop.desktop $out/share/applications/firefly-desktop.desktop
    substituteInPlace $out/share/applications/firefly-desktop.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=firefly-desktop' \
      --replace-fail 'Icon=desktop' 'Icon=firefly-desktop'
    install -D ${appimageContents}/desktop.png $out/share/icons/hicolor/1024x1024/apps/firefly-desktop.png
  '';

  meta = {
    description = "IOTA's New Wallet";
    homepage = "https://firefly.iota.org";
    license = lib.licenses.asl20;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "firefly-desktop";
  };
}

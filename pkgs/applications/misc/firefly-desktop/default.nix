{ lib, fetchurl, appimageTools }:

let
  pname = "firefly-desktop";
  version = "2.1.8";
  src = fetchurl {
    url = "https://github.com/iotaledger/firefly/releases/download/desktop-${version}/${pname}-${version}.AppImage";
    sha256 = "sha256-MATMl5eEIauDQpz8/wqIzD7IugPVZ2HJAWCbDM4n+hA=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: [ pkgs.libsecret ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/pixmaps
    cp ${appimageContents}/desktop.desktop $out/share/applications/firefly-desktop.desktop
    substituteInPlace $out/share/applications/firefly-desktop.desktop \
      --replace 'Exec=AppRun' 'Exec=firefly-desktop' \
      --replace 'Icon=desktop' 'Icon=firefly-desktop'
    cp ${appimageContents}/desktop.png $out/share/pixmaps/firefly-desktop.png
  '';

  meta = with lib; {
    description = "IOTA's New Wallet";
    homepage = "https://firefly.iota.org";
    license = licenses.asl20;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "firefly-desktop";
  };
}

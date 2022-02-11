{ lib, fetchurl, appimageTools }:

let
  pname = "firefly-desktop";
  version = "1.2.0";
  src = fetchurl {
    url = "https://github.com/iotaledger/firefly/releases/download/desktop-${version}/${pname}-${version}.AppImage";
    sha256 = "f3162efcf0407614fd1351af50e95ef180400b747a5cc6b82bc840828a15548d";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: (appimageTools.defaultFhsEnvArgs.multiPkgs pkgs) ++ [ pkgs.libsecret ];

  extraInstallCommands = ''
    mkdir -p $out/share/applications $out/share/pixmaps
    mv $out/bin/${pname}-${version} $out/bin/firefly-desktop
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
    maintainers = with maintainers; [ wolfangaukang ];
    platforms = [ "x86_64-linux" ];
  };
}

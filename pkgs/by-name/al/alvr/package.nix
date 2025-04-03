{
  lib,
  appimageTools,
  fetchurl,
}:
let
  pname = "alvr";
  version = "20.6.1";
  src = fetchurl {
    url = "https://github.com/alvr-org/ALVR/releases/download/v${version}/ALVR-x86_64.AppImage";
    hash = "sha256-IYw3D18xUGWiFu74c4d8d4tohZztAD6mmZCYsDNxR+A=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/alvr.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/alvr.desktop \
      --replace-fail 'Exec=alvr_dashboard' 'Exec=alvr'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Stream VR games from your PC to your headset via Wi-Fi";
    homepage = "https://github.com/alvr-org/ALVR/";
    changelog = "https://github.com/alvr-org/ALVR/releases/tag/v${version}";
    license = licenses.mit;
    mainProgram = "alvr";
    maintainers = with maintainers; [ passivelemon ];
    platforms = [ "x86_64-linux" ];
  };
}

{
  lib,
  fetchurl,
  appimageTools,
}:

let
  pname = "cozydrive";
  version = "3.42.0";

  src = fetchurl {
    url = "https://github.com/cozy-labs/cozy-desktop/releases/download/v${version}/Cozy-Drive-${version}-x86_64.AppImage";
    sha256 = "sha256-1MsRxLp+IZAoj9yqo5n0N1kfRYmYR2tjIjnlbRPrKH4=";
  };
  appimageContents = appimageTools.extract { inherit pname version src; };

in
appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/cozydrive.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/cozydrive.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Cozy Drive is a synchronization tool for your files and folders with Cozy Cloud";
    homepage = "https://cozy.io";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ simarra ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "cozydrive";
  };
}

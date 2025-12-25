{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "requestly";
  version = "25.12.15";

  src = fetchurl {
    url = "https://github.com/requestly/requestly-desktop-app/releases/download/v${version}/Requestly-${version}.AppImage";
    hash = "sha256-XaWR4an57Tabo1uiH4w3aG/6ie99yK55CuW7x7RMANA=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Intercept & Modify HTTP Requests";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    homepage = "https://requestly.io";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ dit7ya ];
    mainProgram = "requestly";
  };
}

{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "requestly";
  version = "26.6.22";

  src = fetchurl {
    url = "https://github.com/requestly/requestly-desktop-app/releases/download/v${version}/Requestly-${version}.AppImage";
    hash = "sha256-lAVkDKEdj+3FQ2vwchDSgnPQYJoSz7kXDizy8T/2gyY=";
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
    maintainers = [ ];
    mainProgram = "requestly";
  };
}

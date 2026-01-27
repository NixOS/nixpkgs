{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "requestly";
  version = "26.1.6";

  src = fetchurl {
    url = "https://github.com/requestly/requestly-desktop-app/releases/download/v${version}/Requestly-${version}.AppImage";
    hash = "sha256-h0gz0W/rQPLjoelyMZqip5H+zEtQG8F414ultP2J36s=";
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

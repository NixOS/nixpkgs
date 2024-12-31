{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "requestly";
  version = "1.6.0";

  src = fetchurl {
    url = "https://github.com/requestly/requestly-desktop-app/releases/download/v${version}/Requestly-${version}.AppImage";
    hash = "sha256-aUhgn6QeCHcs3yi1KKzw+yOUucbTOeNqObTYZTkKqrs=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share
  '';

  meta = with lib; {
    description = "Intercept & Modify HTTP Requests";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    homepage = "https://requestly.io";
    license = licenses.agpl3Only;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "requestly";
  };
}

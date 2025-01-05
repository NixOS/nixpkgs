{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "mockoon";
  version = "6.1.0";

  src = fetchurl {
    url = "https://github.com/mockoon/mockoon/releases/download/v${version}/mockoon-${version}.AppImage";
    hash = "sha256-harZU3TTIzfJoY/jAQI0dm7YSOr24Y9xk9L5ZaBLdD8=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };
in

appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm 444 ${appimageContents}/${pname}.desktop -t $out/share/applications
    cp -r ${appimageContents}/usr/share/icons $out/share

    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Easiest and quickest way to run mock APIs locally";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    homepage = "https://mockoon.com";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "mockoon";
  };
}

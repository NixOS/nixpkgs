{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "mockoon";
  version = "9.1.0";

  src = fetchurl {
    url = "https://github.com/mockoon/mockoon/releases/download/v${version}/mockoon-${version}.x86_64.AppImage";
    hash = "sha256-54E8o8m192yVuuLu3n4I9KRsC5h1UYBZ/1m0n5vGSdY=";
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
    longDescription = ''
      Mockoon is the easiest and quickest way to run mock APIs locally.
      No remote deployment, no account required, free and open-source.
    '';
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    homepage = "https://mockoon.com";
    changelog = "https://github.com/mockoon/mockoon/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ dit7ya ];
    mainProgram = "mockoon";
    platforms = [ "x86_64-linux" ];
  };
}

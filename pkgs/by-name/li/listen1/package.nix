{ lib, fetchurl, appimageTools }:

let
  pname = "listen1";
  version = "2.32.0";
  src = fetchurl {
    url = "https://github.com/listen1/listen1_desktop/releases/download/v${version}/listen1_${version}_linux_x86_64.AppImage";
    hash = "sha256-+whoBVl3pg6pnM1DR7FiBFTU1i9MsauUnnU76mOF6Qk=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/listen1.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/listen1.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
    install -m 444 -D ${appimageContents}/usr/share/icons/hicolor/512x512/apps/listen1.png \
      $out/share/icons/hicolor/512x512/apps/listen1.png
  '';

  meta = with lib; {
    description = "One for all free music in China";
    homepage = "http://listen1.github.io/listen1/";
    license = licenses.mit;
    maintainers = with maintainers; [ running-grass ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "listen1";
  };
}

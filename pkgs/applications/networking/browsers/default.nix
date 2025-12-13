{
  lib,
  fetchurl,
  appimageTools,
}:
let
  pname = "helium";
  version = "0.7.3.1";
  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-x86_64.AppImage";
    sha256 = "sha256-rYxAOGgjEP7/LZS3z3C3XodsV+TkDl3p3VbdSozHFfY=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in appimageTools.wrapType2 {
  inherit pname version src;
  extraInstallCommands = ''
    install -m 444 -D ${appimageContents}/helium.desktop $out/share/applications/helium.desktop
    install -m 444 -D ${appimageContents}/helium.png $out/share/pixmaps/helium.png
    substituteInPlace $out/share/applications/helium.desktop \
      --replace 'Exec=AppRun' 'Exec=${pname}'
  '';
  meta = with lib; {
    description = "Privacy-focused Chromium-based browser with ad-blocking by default";
    homepage = "https://helium.computer/";
    license = licenses.gpl3;
    maintainers = with maintainers; [ qxrein ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "helium";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}

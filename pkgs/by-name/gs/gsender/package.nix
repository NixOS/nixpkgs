{
  lib,
  appimageTools,
  fetchurl,
}:

let
  version = "1.5.7";
  pname = "gsender";

  src = fetchurl {
    url = "https://github.com/Sienci-Labs/gsender/releases/download/v${version}/gSender-${version}-Linux-Intel-64Bit.AppImage";
    hash = "sha256-J+GpDJ1PU07sxAmLON3GLE6RnsrSGPYfhsdESsFU/jQ=";
  };

  appimageContents = appimageTools.extractType2 { inherit pname version src; };

in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/gsender.desktop -t $out/share/applications/
    install -Dm444 ${appimageContents}/gsender.png -t $out/share/icons/hicolor/512x512/apps/

    substituteInPlace $out/share/applications/gsender.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=${meta.mainProgram}'
  '';

  meta = {
    description = "G-code sender for grbl and grblHAL-based CNCs";
    homepage = "https://sienci.com/gsender/";
    downloadPage = "https://resources.sienci.com/view/gs-installation/";
    changelog = "https://github.com/Sienci-Labs/gsender/releases/tag/v${version}";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ FlorisMenninga ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "gsender";
  };
}

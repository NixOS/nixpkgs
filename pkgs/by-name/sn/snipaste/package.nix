{
  appimageTools,
  lib,
  fetchurl,
}:
let
  pname = "snipaste";
  version = "2.10.5";
  src = fetchurl {
    url = "https://download.snipaste.com/archives/Snipaste-${version}-x86_64.AppImage";
    hash = "sha256-E6B60Z0AqY2BhkP52MaoUZc+sTlcRQLcb9hJ6Pw07yU=";
  };
  contents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;
  passthru.updateScript = ./update.sh;

  extraInstallCommands = ''
    install -d $out/share/{applications,icons}
    cp ${contents}/usr/share/applications/*.desktop -t $out/share/applications/
    cp -r ${contents}/usr/share/icons/* -t $out/share/icons/
    substituteInPlace $out/share/applications/*.desktop --replace-warn 'Exec=Snipaste' 'Exec=${pname}'
  '';

  meta = {
    description = "Screenshot tools";
    homepage = "https://www.snipaste.com/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      luftmensch-luftmensch
      ltrump
    ];
    mainProgram = "snipaste";
    platforms = [ "x86_64-linux" ];
    sourceProvenance = [ lib.sourceTypes.binaryNativeCode ];
  };
}

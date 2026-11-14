{
  lib,
  fetchurl,
  appimageTools,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "listen1";
  version = "2.33.0";
  src = fetchurl {
    url = "https://github.com/listen1/listen1_desktop/releases/download/v${finalAttrs.version}/listen1_${finalAttrs.version}_linux_x86_64.AppImage";
    hash = "sha256-RMpusz9bNrHpN23HrncjteiIGkLJgsP7FS2t7zD1Ud0=";
  };

  extraInstallCommands = ''
    install -m 444 -D ${finalAttrs.contents}/listen1.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/listen1.desktop \
      --replace 'Exec=AppRun' 'Exec=${finalAttrs.pname}'
    install -m 444 -D ${finalAttrs.contents}/usr/share/icons/hicolor/512x512/apps/listen1.png \
      $out/share/icons/hicolor/512x512/apps/listen1.png
  '';

  meta = {
    description = "One for all free music in China";
    homepage = "http://listen1.github.io/listen1/";
    license = lib.licenses.mit;
    maintainers = [ ];
    platforms = [ "x86_64-linux" ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    mainProgram = "listen1";
  };
})

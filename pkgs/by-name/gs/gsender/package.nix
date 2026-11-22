{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 (finalAttrs: {
  version = "1.6.5";
  pname = "gsender";

  src = fetchurl {
    url = "https://github.com/Sienci-Labs/gsender/releases/download/v${finalAttrs.version}/gSender-${finalAttrs.version}-Linux-Intel-64Bit.AppImage";
    hash = "sha256-TyNpwJWdY8NO0BHznrsTPu/EbOh73Jih4BhkN8S7xZY=";
  };

  extraInstallCommands = ''
    install -Dm444 ${finalAttrs.contents}/gsender.desktop -t $out/share/applications/
    install -Dm444 ${finalAttrs.contents}/gsender.png -t $out/share/icons/hicolor/512x512/apps/

    substituteInPlace $out/share/applications/gsender.desktop \
      --replace-fail 'Exec=AppRun' 'Exec=gsender'
  '';

  meta = {
    description = "G-code sender for grbl and grblHAL-based CNCs";
    homepage = "https://sienci.com/gsender/";
    downloadPage = "https://resources.sienci.com/view/gs-installation/";
    changelog = "https://github.com/Sienci-Labs/gsender/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.gpl3Plus;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ FlorisMenninga ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "gsender";
  };
})

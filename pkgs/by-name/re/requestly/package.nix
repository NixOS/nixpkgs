{
  lib,
  appimageTools,
  fetchurl,
}:

appimageTools.wrapType2 (finalAttrs: {
  pname = "requestly";
  version = "26.6.29";
  src = fetchurl {
    url = "https://github.com/requestly/requestly-desktop-app/releases/download/v${finalAttrs.version}/Requestly-${finalAttrs.version}.AppImage";
    hash = "sha256-TnHEt5CCGNb75KtDEzuDbkqba6V5Kqkl1JkPfHT6dPI=";
  };

  extraInstallCommands = ''
    install -Dm 444 ${finalAttrs.contents}/${finalAttrs.pname}.desktop -t $out/share/applications
    cp -r ${finalAttrs.contents}/usr/share/icons $out/share
  '';

  meta = {
    description = "Intercept & Modify HTTP Requests";
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    homepage = "https://requestly.io";
    license = lib.licenses.agpl3Only;
    maintainers = [ ];
    mainProgram = "requestly";
  };
})

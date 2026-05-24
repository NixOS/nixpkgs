{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "fflogs";
  version = "9.3.17";
  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-fflogs/releases/download/v${version}/fflogs-v${version}.AppImage";
    hash = "sha256-EYo65CerGE14kQadNIaVyANvyBig/yW1PfulAAE6dxo=";
  };
  extracted = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp -r ${extracted}/usr/share/icons/hicolor/512x512/apps/'FF Logs Uploader.png' $out/share/icons/hicolor/512x512/apps/fflogs.png
    chmod -R +w $out/share/
    test ! -e $out/share/icons/hicolor/0x0 # check for regression of https://github.com/electron-userland/electron-builder/issues/5294
    cp ${extracted}/'FF Logs Uploader.desktop' $out/share/applications/fflogs.desktop
    sed -i 's@^Exec=AppRun --no-sandbox@Exec=fflogs@g' $out/share/applications/fflogs.desktop
    sed -i 's@^Icon=FF Logs Uploader@Icon=fflogs@g' $out/share/applications/fflogs.desktop
  '';

  meta = {
    description = "Application for uploading Final Fantasy XIV combat logs to fflogs.com";
    homepage = "https://www.fflogs.com/client/download";
    downloadPage = "https://github.com/RPGLogs/Uploaders-fflogs/releases/latest";
    license = lib.licenses.unfree; # no license listed
    mainProgram = "fflogs";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ keysmashes ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
  };
}

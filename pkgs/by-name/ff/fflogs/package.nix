{
  lib,
  appimageTools,
  fetchurl,
}:

let
  pname = "fflogs";
<<<<<<< HEAD
  version = "8.17.115";
  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-fflogs/releases/download/v${version}/fflogs-v${version}.AppImage";
    hash = "sha256-i16jMTbthl+XvL/I6tOqBKBdKyb6wOLYIQeWveR4Oyg=";
=======
  version = "8.17.101";
  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-fflogs/releases/download/v${version}/fflogs-v${version}.AppImage";
    hash = "sha256-yCnFN46/vHrQA8KkaoWQUBCOZ1+6Oa4UkdUhCghGByo=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
  extracted = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp -r ${extracted}/usr/share/icons $out/share/
    chmod -R +w $out/share/
    test ! -e $out/share/icons/hicolor/0x0 # check for regression of https://github.com/electron-userland/electron-builder/issues/5294
    cp ${extracted}/'FF Logs Uploader.desktop' $out/share/applications/fflogs.desktop
    sed -i 's@^Exec=AppRun --no-sandbox@Exec=fflogs@g' $out/share/applications/fflogs.desktop
  '';

<<<<<<< HEAD
  meta = {
    description = "Application for uploading Final Fantasy XIV combat logs to fflogs.com";
    homepage = "https://www.fflogs.com/client/download";
    downloadPage = "https://github.com/RPGLogs/Uploaders-fflogs/releases/latest";
    license = lib.licenses.unfree; # no license listed
    mainProgram = "fflogs";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ keysmashes ];
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
=======
  meta = with lib; {
    description = "Application for uploading Final Fantasy XIV combat logs to fflogs.com";
    homepage = "https://www.fflogs.com/client/download";
    downloadPage = "https://github.com/RPGLogs/Uploaders-fflogs/releases/latest";
    license = licenses.unfree; # no license listed
    mainProgram = "fflogs";
    platforms = platforms.linux;
    maintainers = with maintainers; [ keysmashes ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

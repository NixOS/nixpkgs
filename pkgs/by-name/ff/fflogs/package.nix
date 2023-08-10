{ lib
, appimageTools
, fetchurl
}:

let
  pname = "fflogs";
  version = "8.3.20";
  src = fetchurl {
    url = "https://github.com/RPGLogs/Uploaders-fflogs/releases/download/v${version}/fflogs-v${version}.AppImage";
    sha256 = "1631z7d9kipkkh1ikywbsnv8m5mip5mgklsvw7b0lhiillfszhbp";
  };
  extracted = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    mkdir -p $out/share/applications
    cp -r ${extracted}/usr/share/icons $out/share/
    cp ${extracted}/fflogs.desktop $out/share/applications/
    sed -i s@^Exec=.\*@Exec=$out/bin/${pname}-${version}@g $out/share/applications/fflogs.desktop
  '';

  meta = with lib; {
    description = "An application for uploading Final Fantasy XIV combat logs to fflogs.com";
    homepage = "https://www.fflogs.com/client/download";
    downloadPage = "https://github.com/RPGLogs/Uploaders-fflogs/releases/latest";
    license = licenses.unfree; # no license listed
    mainProgram = "fflogs-${version}";
    platforms = platforms.linux;
    maintainers = with maintainers; [ sersorrel ];
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
  };
}

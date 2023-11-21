{ lib, appimageTools, fetchurl }:

let
  version = "0.9.9.6";
  pname = "hifile";

  src = fetchurl {
    url = "https://www.hifile.app/files/HiFile-${version}.AppImage";
    hash = "sha256-qfBV4w4nChH2wUAHdcUFwVs+3OeqcKqMJ8WUucn31q4=";
  };

  appimageContents = appimageTools.extractType2 {
    inherit pname version src;
  };

in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/${pname}-${version} $out/bin/${pname}

    install -m 444 -D ${appimageContents}/HiFile.desktop $out/share/applications/HiFile.desktop
    install -m 444 -D ${appimageContents}/HiFile.png $out/share/icons/hicolor/512x512/apps/HiFile.png
    substituteInPlace $out/share/applications/HiFile.desktop \
      --replace 'Exec=HiFile' 'Exec=${pname}'
  '';

  meta = with lib; {
    description = "Dual-pane graphical file manager for Windows, macOS and Linux";
    longDescription = ''
      HiFile is the next evolution of file managers. Its mission is to increase your productivity whenever you work with files or folders. It aims to be better in every way - more convenient, more versatile, more efficient, more elegant, more customizable, and more fun.
    '';
    homepage = "https://www.hifile.app/";
    downloadPage = "https://www.hifile.app/download";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ ymstnt ];
    platforms = [ "x86_64-linux" ];
  };
}

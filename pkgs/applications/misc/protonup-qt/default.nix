{ appimageTools, fetchurl, lib }:
let
  pname = "protonup-qt";
  version = "2.7.4";
  src = fetchurl {
    url = "https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v${version}/ProtonUp-Qt-${version}-x86_64.AppImage";
    sha256 = "yKc+KOQfqciqULnChVLf6y9npoSYM6Fmu7mYGEKmpkA=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 rec {
  inherit pname version src;

  extraInstallCommands = ''
    mv $out/bin/{${pname}-${version},${pname}}
    mkdir -p $out/share/{applications,pixmaps}
    cp ${appimageContents}/net.davidotek.pupgui2.desktop $out/share/applications/${pname}.desktop
    cp ${appimageContents}/net.davidotek.pupgui2.png $out/share/pixmaps/${pname}.png
    substituteInPlace $out/share/applications/${pname}.desktop \
      --replace 'Exec=net.davidotek.pupgui2' 'Exec=${pname}' \
      --replace 'Icon=net.davidotek.pupgui2' 'Icon=${pname}'
  '';

  meta = with lib; {
    homepage = "https://davidotek.github.io/protonup-qt/";
    description = "Install and manage Proton-GE and Luxtorpeda for Steam and Wine-GE for Lutris with this graphical user interface.";
    license = licenses.gpl3;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    mainProgram = "protonup-qt";
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ michaelBelsanti ];
  };
}

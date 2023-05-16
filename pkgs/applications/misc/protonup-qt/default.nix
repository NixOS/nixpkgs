{ appimageTools, fetchurl, lib }:
let
  pname = "protonup-qt";
<<<<<<< HEAD
  version = "2.8.0";
  src = fetchurl {
    url = "https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v${version}/ProtonUp-Qt-${version}-x86_64.AppImage";
    hash = "sha256-o3Tsrdrj5qDcTqhdgdf4Lcpp9zfBQY+/l3Ohm1A/pm4=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 {
=======
  version = "2.7.7";
  src = fetchurl {
    url = "https://github.com/DavidoTek/ProtonUp-Qt/releases/download/v${version}/ProtonUp-Qt-${version}-x86_64.AppImage";
    sha256 = "sha256-eDi13DYS4Rtj3ouuhRoET1Ctc4D7p50khqXNOSBIvto=";
  };
  appimageContents = appimageTools.extractType2 { inherit pname version src; };
in
appimageTools.wrapType2 rec {
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
    changelog = "https://github.com/DavidoTek/ProtonUp-Qt/releases/tag/v${version}";
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ michaelBelsanti ];
  };
}

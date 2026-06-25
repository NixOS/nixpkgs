{
  lib,
  appimageTools,
  fetchurl,
  makeFontsConf,
  makeDesktopItem,
  glib,
  util-linux,
  ibm-plex,
}:

let
  pname = "hyneview";
  version = "4.6.2";

  src = fetchurl {
    url = "https://download.diateam.net/hyneview/linux/${version}/DIATEAM_Cyber_Range_hyneview_${version}.AppImage";
    hash = "sha256-sUHcTlquXvEu8NnQ0L7a5A7azUoO387L2J2X0KiJhFo=";
  };

  desktopItem = makeDesktopItem {
    name = "hyneview";
    desktopName = "Hyneview";
    comment = "Visualization tool for DIATEAM Cyber Range";
    exec = "hyneview";
    categories = [ "Development" ];
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  profile =
    let
      myFontsConf = makeFontsConf {
        fontDirectories = [ ibm-plex ];
      };
    in
    ''
      export LD_PRELOAD="${lib.makeLibraryPath [ glib ]}/libglib-2.0.so.0:${lib.makeLibraryPath [ glib ]}/libgio-2.0.so.0:${lib.makeLibraryPath [ glib ]}/libgmodule-2.0.so.0:${
        lib.makeLibraryPath [ util-linux ]
      }/libmount.so.1"
      export FONTCONFIG_FILE="${myFontsConf}"
    '';

  extraPkgs = pkgs: [ ];

  extraInstallCommands = ''
    install -Dm444 -t $out/share/applications ${desktopItem}/share/applications/*
  '';

  meta = with lib; {
    description = "Visualization tool for DIATEAM Cyber Range";
    homepage = "https://diateam.net/";
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    license = licenses.unfree;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ BaptTF ];
    mainProgram = "hyneview";
  };
}

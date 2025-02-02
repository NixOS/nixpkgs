{
  appimageTools,
  fetchurl,
  makeDesktopItem,
  lib,
}:
let
  pname = "lycheeSlicer";
  version = "7.2.0";

  src = fetchurl {
    url = "https://mango-lychee.nyc3.cdn.digitaloceanspaces.com/LycheeSlicer-${version}.AppImage";
    hash = "sha256-ZGNTEWGrmrzHmFijDaAizuxfhHW7k+ReoTrG4mGEcog=";
  };

  desktopItem = makeDesktopItem {
    name = "Lychee Slicer";
    genericName = "Resin Slicer";
    comment = "All-in-one 3D slicer for Resin and Filament";
    desktopName = "Lychee";
    noDisplay = false;
    exec = "lychee";
    terminal = false;
    mimeTypes = [ "model/stl" ];
    categories = [ "Graphics" ];
    keywords = [
      "STL"
      "Slicer"
      "Printing"
    ];
  };

in
appimageTools.wrapType2 {
  inherit pname version src;

  extraInstallCommands = ''
    install -Dm444 -t $out/share/applications ${desktopItem}/share/applications/*
  '';

  meta = with lib; {
    description = "An all-in-one 3D slicer for resin and FDM printers.";
    homepage = "https://lychee.mango3d.io/";
    license = licenses.unfree;
    maintainers = with maintainers; [ tarinaky ];
    platforms = [ "x86_64-linux" ];
  };
}

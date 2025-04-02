{
  appimageTools,
  fetchurl,
  makeDesktopItem,
  lib,
  xorg,
}:
let
  pname = "LycheeSlicer";
  version = "7.3.1";

  src = fetchurl {
    url = "https://mango-lychee.nyc3.cdn.digitaloceanspaces.com/LycheeSlicer-${version}.AppImage";
    hash = "sha256-21ySVT2Un/WAWxvEAH5GfrumGbsSaeNVjaMsL9mYwsg=";
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

  buildInputs = [
    xorg.libxshmfence
  ];

  meta = {
    description = "All-in-one 3D slicer for resin and FDM printers";
    homepage = "https://lychee.mango3d.io/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [ tarinaky ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "lychee";
  };
}

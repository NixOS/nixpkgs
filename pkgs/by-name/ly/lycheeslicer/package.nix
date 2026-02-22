{
  appimageTools,
  fetchurl,
  makeDesktopItem,
  lib,
  libxshmfence,
  wayland,
  wayland-protocols,
}:
let
  pname = "lycheeslicer";
  version = "7.6.1";

  src = fetchurl {
    url = "https://mango-lychee.nyc3.cdn.digitaloceanspaces.com/LycheeSlicer-${version}.AppImage";
    hash = "sha256-649Lf6bh1Saee0NrHZ+wqoOUgpy4lxMD2DV7lh6ZNik=";
  };

  desktopItem = makeDesktopItem {
    name = "Lychee Slicer";
    genericName = "Resin Slicer";
    comment = "All-in-one 3D slicer for Resin and Filament";
    desktopName = "LycheeSlicer";
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

  extraPkgs = _: [
    libxshmfence
    wayland
    wayland-protocols
  ];

  meta = {
    description = "All-in-one 3D slicer for resin and FDM printers";
    homepage = "https://lychee.mango3d.io/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      tarinaky
      ZachDavies
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "LycheeSlicer";
  };
}

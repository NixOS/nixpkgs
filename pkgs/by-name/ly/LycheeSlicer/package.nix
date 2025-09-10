{
  appimageTools,
  fetchurl,
  makeDesktopItem,
  lib,
  xorg,
  wayland,
  wayland-protocols,
}:
let
  pname = "LycheeSlicer";
  version = "7.4.4";

  src = fetchurl {
    url = "https://mango-lychee.nyc3.cdn.digitaloceanspaces.com/LycheeSlicer-${version}.AppImage";
    hash = "sha256-ZbKMCbTKqdjcTefEfrhovRQSRydKf3QBsXHi/XwXuUc=";
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
    xorg.libxshmfence
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

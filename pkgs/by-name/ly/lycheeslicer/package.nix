{
  appimageTools,
  fetchurl,
  makeDesktopItem,
  lib,
  libxshmfence,
  stdenv,
  runCommand,
  wayland,
  wayland-protocols,
}:
let
  pname = "lycheeslicer";
  version = "8.0.3";

  src = fetchurl {
    url = "https://mango-lychee.nyc3.cdn.digitaloceanspaces.com/LycheeSlicer-${version}-x86_64.GLIB-235.AppImage";
    hash = "sha256-djXiUB2hak7pcmmHQAm/bWOk7b9YHHRQbgriLRN11Ik=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };

  preload =
    runCommand "lycheeslicer-preload"
      {
        nativeBuildInputs = [ stdenv.cc ];
      }
      ''
        mkdir -p $out/lib
        $CC -shared -fPIC -O2 ${./preload.c} -o $out/lib/liblychee-preload.so -ldl
      '';

  desktopItem = makeDesktopItem {
    name = "lycheeslicer";
    desktopName = "LycheeSlicer";
    genericName = "Resin Slicer";
    comment = "All-in-one 3D slicer for Resin and Filament";
    icon = "lycheeslicer";
    exec = "lycheeslicer %U";
    terminal = false;
    mimeTypes = [
      "application/x-lychee-slicer"
      "application/x-lycheeslicer-scene"
      "model/stl"
      "x-scheme-handler/lycheeslicer"
    ];
    categories = [
      "Graphics"
      "3DGraphics"
      "Engineering"
    ];
    keywords = [
      "3d"
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
    ln -s lycheeslicer.desktop $out/share/applications/LycheeSlicer.desktop
    ln -s lycheeslicer.desktop $out/share/applications/lychee-slicer.desktop
    ln -s lycheeslicer.desktop "$out/share/applications/Lychee Slicer.desktop"

    install -Dm444 ${appimageContents}/usr/share/icons/hicolor/scalable/apps/LycheeSlicer.svg \
      $out/share/icons/hicolor/scalable/apps/lycheeslicer.svg
    ln -s lycheeslicer.svg $out/share/icons/hicolor/scalable/apps/LycheeSlicer.svg
  '';

  extraPkgs = _: [
    libxshmfence
    wayland
    wayland-protocols
    preload
  ];

  profile = ''
    export LD_PRELOAD="/lib/liblychee-preload.so''${LD_PRELOAD:+:$LD_PRELOAD}"
  '';

  meta = {
    description = "All-in-one 3D slicer for resin and FDM printers";
    homepage = "https://lychee.mango3d.io/";
    license = lib.licenses.unfree;
    maintainers = with lib.maintainers; [
      tarinaky
      ZachDavies
    ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "lycheeslicer";
  };
}

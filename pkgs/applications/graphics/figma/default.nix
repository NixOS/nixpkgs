{ pkgs, lib
# Specify any font packages to include
# e.g. figma.override { fonts = [ noto-fonts fira-code ]; }
, fonts ? [ ], ... }:

with pkgs;
let
  version = "0.8.1";
  # Figma executable.
  # Currently won't run outside of FHS even with autopatching - needs help.
  figma-exec = stdenv.mkDerivation rec {
    inherit version;
    pname = "figma-exec";
    src = fetchurl {
      url = "https://github.com/Figma-Linux/figma-linux/releases/download/v${version}/figma-linux_${version}_linux_amd64.zip";
      sha256 = "sha256-LqcjFLQeEQx/3HFy0mPoIynFy704omYVxv42IsY7s8k=";
    };
    buildInputs = [ unzip ];
    unpackPhase = ''
      runHook preUnpack
      mkdir output
      unzip $src -d output
      runHook postUnpack
    '';
    installPhase = ''
      APPDIR=$out/etc/figma-linux
      # Copy application to etc
      mkdir -p $out/etc/figma-linux
      cp -r output/. $APPDIR

      # Add icons
      for size in 24 36 48 64 72 96 128 192 256 384 512; do
        mkdir -p "$out/share/icons/hicolor/''${size}x''${size}/apps"
        cp -rf "$APPDIR/icons/''${size}x''${size}.png" "$out/share/icons/hicolor/''${size}x''${size}/apps/figma-linux.png"
      done
      mkdir -p "$out/share/icons/hicolor/scalable/apps"
      cp -rf "$APPDIR/icons/scalable.svg" "$out/share/icons/hicolor/scalable/apps/figma-linux.svg"

      # Copy fonts
      mkdir -p $out/share/fonts
      ${lib.concatMapStringsSep "\n"
      (f: "cp -r ${f}/share/fonts/. $out/share/fonts/") fonts}

      # Link binary
      mkdir -p $out/bin
      ln -s $out/etc/figma-linux/figma-linux $out/bin/figma

      # Link desktop item
      mkdir -p $out/share/applications
      ln -s ${desktopItem}/share/applications/* $out/share/applications
    '';
    desktopItem = makeDesktopItem {
      name = "Figma";
      exec = "figma";
      icon = "figma-linux";
      desktopName = "Figma";
      genericName = "Vector Graphics Designer";
      comment = "Unofficial desktop application for linux";
      type = "Application";
      categories = "Graphics;";
      mimeType = "application/figma;x-scheme-handler/figma;";
      extraDesktopEntries = { StartupWMClass = "figma-linux"; };
    };
  };
  figma-fhs = buildFHSUserEnv {
    name = "figma-fhs";
    targetPkgs = pkgs: [
      figma-exec
      alsaLib
      at_spi2_atk
      at_spi2_core
      atk
      avahi
      brotli
      cairo
      cups
      dbus
      expat
      freetype
      pango
      gcc
      glib
      glibc
      gdk_pixbuf
      gtk3
      icu
      libxkbcommon
      mesa
      ffmpeg
      libdrm
      libGL
      nss_3_53
      nspr
      udev
      xorg.libXdamage
      xorg.libXext
      xorg.libX11
      xorg.libXau
      xorg.libxcb
      xorg.libXcomposite
      xorg.libXdmcp
      xorg.libXfixes
      xorg.libXrender
      xorg.libXrandr
      xorg.libxshmfence
      wayland
    ];
    runScript = "figma";
  };

in stdenv.mkDerivation {
  pname = "figma";
  inherit version;
  src = builtins.path { path = ./.; };
  nativeBuildInputs = [ figma-fhs ];
  installPhase = ''
    # Add binary link
    mkdir -p $out/bin
    cp -r ${figma-fhs}/bin/figma-fhs $out/bin/figma

    # Link icons + desktop items
    mkdir -p $out/share
    cp -r ${figma-exec}/share/. $out/share
  '';
  meta = with lib; {
    description = "unofficial Electron-based Figma desktop app for Linux";
    homepage = "https://github.com/Figma-Linux/figma-linux";
    # While the container application is GPL-2.0,
    # Figma itself (running in the application) is nonFree.
    license = licenses.unfree;
  };
}

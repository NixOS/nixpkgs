{ stdenv, lib, fetchurl, makeDesktopItem, copyDesktopItems, dpkg, atk, glib, pango
, gdk-pixbuf, gnome2, gtk3, cairo, freetype, fontconfig, dbus, libXi, libXcursor
, libXdamage, libXrandr, libXcomposite, libXext, libXfixes, libXrender, libX11, libXtst
, libXScrnSaver, libxcb, nss, nspr, alsa-lib, cups, expat, udev, libpulseaudio
, at-spi2-atk, at-spi2-core, libxshmfence, libdrm, libxkbcommon, mesa }:

let
  libPath = lib.makeLibraryPath [
    stdenv.cc.cc gtk3 gnome2.GConf atk glib pango gdk-pixbuf cairo freetype fontconfig dbus
    libXi libXcursor libXdamage libXrandr libXcomposite libXext libXfixes libxcb
    libXrender libX11 libXtst libXScrnSaver nss nspr alsa-lib cups expat udev libpulseaudio
    at-spi2-atk at-spi2-core libxshmfence libdrm libxkbcommon mesa
  ];

in
stdenv.mkDerivation rec {
  pname = "hyper";
  version = "3.1.1";

  src = fetchurl {
    url = "https://github.com/vercel/hyper/releases/download/v${version}/hyper_${version}_amd64.deb";
    sha256 = "0j999z649k63rnr1lpbansaxnkrhrp73jdrdmslgnwbh7z1wsp9p";
  };

  buildInputs = [ copyDesktopItems dpkg ];

  desktopItems = makeDesktopItem {
    type = "Application";
    name = pname;
    desktopName = "Hyper";
    genericName = "Hyper Terminal";
    exec = "hyper";
    icon = "hyper";
    categories = "System;TerminalEmulator;";
  };

  unpackPhase = ''
    mkdir pkg
    dpkg-deb -x $src pkg
    sourceRoot=pkg
  '';

  installPhase = ''
    mkdir -p "$out/bin"
    mv opt "$out/"

    ln -s "$out/opt/Hyper/hyper" "$out/bin/hyper"
    patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" --set-rpath "${libPath}:$out/opt/Hyper:\$ORIGIN" "$out/opt/Hyper/hyper"

    mv usr/* "$out/"

    copyDesktopItems ${desktopItems}/share/applications/* $out/share/applications/
  '';

  dontPatchELF = true;
  meta = with lib; {
    description = "A terminal built on web technologies";
    homepage    = "https://hyper.is/";
    maintainers = with maintainers; [ puffnfresh ];
    license     = licenses.mit;
    platforms   = [ "x86_64-linux" ];
  };
}

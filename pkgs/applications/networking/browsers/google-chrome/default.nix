{ stdenv, fetchurl, patchelf, bash

# Linked dynamic libraries.
, glib, fontconfig, freetype, pango, cairo, libX11, libXi, atk, gconf, nss, nspr
, libXcursor, libXext, libXfixes, libXrender, libXScrnSaver, libXcomposite, libxcb
, alsaLib, libXdamage, libXtst, libXrandr, expat, cups
, dbus_libs, gtk2, gtk3, gdk_pixbuf, gcc

# command line arguments which are always set e.g "--disable-gpu"
, commandLineArgs ? ""

# Will crash without.
, systemd

# Loaded at runtime.
, libexif

# Additional dependencies according to other distros.
## Ubuntu
, liberation_ttf, curl, utillinux, xdg_utils, wget
## Arch Linux.
, flac, harfbuzz, icu, libpng, libopus, snappy, speechd
## Gentoo
, bzip2, libcap

# Which distribution channel to use.
, channel ? "stable"

# Necessary for USB audio devices.
, pulseSupport ? true, libpulseaudio ? null

# Only needed for getting information about upstream binaries
, chromium
}:

with stdenv.lib;

with chromium.upstream-info;

let
  opusWithCustomModes = libopus.override {
    withCustomModes = true;
  };

  deps = [
    stdenv.cc.cc
    glib fontconfig freetype pango cairo libX11 libXi atk gconf nss nspr
    libXcursor libXext libXfixes libXrender libXScrnSaver libXcomposite libxcb
    alsaLib libXdamage libXtst libXrandr expat cups
    dbus_libs gdk_pixbuf gcc
    systemd
    libexif
    liberation_ttf curl utillinux xdg_utils wget
    flac harfbuzz icu libpng opusWithCustomModes snappy speechd
    bzip2 libcap
  ] ++ optional pulseSupport libpulseaudio
    ++ (if (versionAtLeast version "59.0.0.0") then [gtk3] else [gtk2]);

  suffix = if channel != "stable" then "-" + channel else "";

in stdenv.mkDerivation rec {
  inherit version;

  name = "google-chrome${suffix}-${version}";

  src = binary;

  buildInputs = [ patchelf ];

  unpackPhase = ''
    ar x $src
    tar xf data.tar.xz
  '';

  rpath = makeLibraryPath deps + ":" + makeSearchPathOutput "lib" "lib64" deps;
  binpath = makeBinPath deps;

  installPhase = ''
    case ${channel} in
      beta) appname=chrome-beta      dist=beta     ;;
      dev)  appname=chrome-unstable  dist=unstable ;;
      *)    appname=chrome           dist=stable   ;;
    esac

    exe=$out/bin/google-chrome-$dist

    mkdir -p $out/bin $out/share

    cp -a opt/* $out/share
    cp -a usr/share/* $out/share

    substituteInPlace $out/share/applications/google-$appname.desktop \
      --replace /usr/bin/google-chrome-$dist $exe
    substituteInPlace $out/share/gnome-control-center/default-apps/google-$appname.xml \
      --replace /opt/google/$appname/google-$appname $exe
    substituteInPlace $out/share/menu/google-$appname.menu \
      --replace /opt $out/share \
      --replace $out/share/google/chrome/google-$appname $exe

    for icon_file in $out/share/google/chrome*/product_logo_*[0-9].png; do
      num_and_suffix="''${icon_file##*logo_}"
      icon_size="''${num_and_suffix%.*}"
      logo_output_prefix="$out/share/icons/hicolor"
      logo_output_path="$logo_output_prefix/''${icon_size}x''${icon_size}/apps"
      mkdir -p "$logo_output_path"
      mv "$icon_file" "$logo_output_path/google-$appname.png"
    done

    cat > $exe << EOF
    #!${bash}/bin/sh
    export LD_LIBRARY_PATH=$rpath\''${LD_LIBRARY_PATH:+:\$LD_LIBRARY_PATH}
    export PATH=$binpath\''${PATH:+:\$PATH}
    $out/share/google/$appname/google-$appname ${commandLineArgs} "\$@"
    EOF
    chmod +x $exe

    for elf in $out/share/google/$appname/{chrome,chrome-sandbox,nacl_helper}; do
      patchelf --set-rpath $rpath $elf
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $elf
    done
  '';

  meta = {
    description = "A freeware web browser developed by Google";
    homepage = https://www.google.com/chrome/browser/;
    license = licenses.unfree;
    maintainers = [ maintainers.msteen ];
    platforms = platforms.linux;
  };
}

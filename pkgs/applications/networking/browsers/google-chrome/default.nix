{ stdenv, patchelf, makeWrapper

# Linked dynamic libraries.
, glib, fontconfig, freetype, pango, cairo, libX11, libXi, atk, gconf, nss, nspr
, libXcursor, libXext, libXfixes, libXrender, libXScrnSaver, libXcomposite, libxcb
, alsaLib, libXdamage, libXtst, libXrandr, libxshmfence, expat, cups
, dbus, gtk2, gtk3, gdk-pixbuf, gcc-unwrapped, at-spi2-atk, at-spi2-core
, kerberos, libdrm, mesa
, libxkbcommon, wayland # ozone/wayland

# Command line programs
, coreutils

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

, gsettings-desktop-schemas
, gnome2, gnome3
}:

with stdenv.lib;

let
  opusWithCustomModes = libopus.override {
    withCustomModes = true;
  };

  version = chromium.upstream-info.version;
  gtk = if (versionAtLeast version "59.0.0.0") then gtk3 else gtk2;
  gnome = if (versionAtLeast version "59.0.0.0") then gnome3 else gnome2;

  deps = [
    glib fontconfig freetype pango cairo libX11 libXi atk gconf nss nspr
    libXcursor libXext libXfixes libXrender libXScrnSaver libXcomposite libxcb
    alsaLib libXdamage libXtst libXrandr libxshmfence expat cups
    dbus gdk-pixbuf gcc-unwrapped.lib
    systemd
    libexif
    liberation_ttf curl utillinux xdg_utils wget
    flac harfbuzz icu libpng opusWithCustomModes snappy speechd
    bzip2 libcap at-spi2-atk at-spi2-core
    kerberos libdrm mesa coreutils
    libxkbcommon wayland
  ] ++ optional pulseSupport libpulseaudio
    ++ [ gtk ];

  suffix = if channel != "stable" then "-" + channel else "";

in stdenv.mkDerivation {
  inherit version;

  name = "google-chrome${suffix}-${version}";

  src = chromium.chromeSrc;

  nativeBuildInputs = [ patchelf makeWrapper ];
  buildInputs = [
    # needed for GSETTINGS_SCHEMAS_PATH
    gsettings-desktop-schemas glib gtk

    # needed for XDG_ICON_DIRS
    gnome.adwaita-icon-theme
  ];

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

    # To fix --use-gl=egl:
    test -e $out/share/google/$appname/libEGL.so
    ln -s libEGL.so $out/share/google/$appname/libEGL.so.1
    test -e $out/share/google/$appname/libGLESv2.so
    ln -s libGLESv2.so $out/share/google/$appname/libGLESv2.so.2

    substituteInPlace $out/share/applications/google-$appname.desktop \
      --replace /usr/bin/google-chrome-$dist $exe
    substituteInPlace $out/share/gnome-control-center/default-apps/google-$appname.xml \
      --replace /opt/google/$appname/google-$appname $exe
    substituteInPlace $out/share/menu/google-$appname.menu \
      --replace /opt $out/share \
      --replace $out/share/google/$appname/google-$appname $exe

    for icon_file in $out/share/google/chrome*/product_logo_[0-9]*.png; do
      num_and_suffix="''${icon_file##*logo_}"
      if [ $dist = "stable" ]; then
        icon_size="''${num_and_suffix%.*}"
      else
        icon_size="''${num_and_suffix%_*}"
      fi
      logo_output_prefix="$out/share/icons/hicolor"
      logo_output_path="$logo_output_prefix/''${icon_size}x''${icon_size}/apps"
      mkdir -p "$logo_output_path"
      mv "$icon_file" "$logo_output_path/google-$appname.png"
    done

    makeWrapper "$out/share/google/$appname/google-$appname" "$exe" \
      --prefix LD_LIBRARY_PATH : "$rpath" \
      --prefix PATH            : "$binpath" \
      --prefix XDG_DATA_DIRS   : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH" \
      --add-flags ${escapeShellArg commandLineArgs}

    for elf in $out/share/google/$appname/{chrome,chrome-sandbox,crashpad_handler,nacl_helper}; do
      patchelf --set-rpath $rpath $elf
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $elf
    done
  '';

  meta = {
    description = "A freeware web browser developed by Google";
    homepage = "https://www.google.com/chrome/browser/";
    license = licenses.unfree;
    maintainers = with maintainers; [ primeos msteen ];
    # Note from primeos: By updating Chromium I also update Google Chrome and
    # will try to merge PRs and respond to issues but I'm not actually using
    # Google Chrome. msteen is the actual user/maintainer.
    platforms = [ "x86_64-linux" ];
  };
}

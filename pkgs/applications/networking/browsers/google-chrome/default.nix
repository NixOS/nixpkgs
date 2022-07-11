{ lib, stdenv, patchelf, makeWrapper

# Linked dynamic libraries.
, glib, fontconfig, freetype, pango, cairo, libX11, libXi, atk, nss, nspr
, libXcursor, libXext, libXfixes, libXrender, libXScrnSaver, libXcomposite, libxcb
, alsa-lib, libXdamage, libXtst, libXrandr, libxshmfence, expat, cups
, dbus, gtk3, gdk-pixbuf, gcc-unwrapped, at-spi2-atk, at-spi2-core
, libkrb5, libdrm, libglvnd, mesa
, libxkbcommon, pipewire, wayland # ozone/wayland

# Command line programs
, coreutils

# command line arguments which are always set e.g "--disable-gpu"
, commandLineArgs ? ""

# Will crash without.
, systemd

# Loaded at runtime.
, libexif, pciutils

# Additional dependencies according to other distros.
## Ubuntu
, liberation_ttf, curl, util-linux, xdg-utils, wget
## Arch Linux.
, flac, harfbuzz, icu, libpng, libopus, snappy, speechd
## Gentoo
, bzip2, libcap

# Which distribution channel to use.
, channel ? "stable"

# Necessary for USB audio devices.
, pulseSupport ? true, libpulseaudio

# Only needed for getting information about upstream binaries
, chromium

, gsettings-desktop-schemas
, gnome

# For video acceleration via VA-API (--enable-features=VaapiVideoDecoder)
, libvaSupport ? true, libva

# For Vulkan support (--enable-features=Vulkan)
, addOpenGLRunpath
}:

with lib;

let
  opusWithCustomModes = libopus.override {
    withCustomModes = true;
  };

  version = chromium.upstream-info.version;

  deps = [
    glib fontconfig freetype pango cairo libX11 libXi atk nss nspr
    libXcursor libXext libXfixes libXrender libXScrnSaver libXcomposite libxcb
    alsa-lib libXdamage libXtst libXrandr libxshmfence expat cups
    dbus gdk-pixbuf gcc-unwrapped.lib
    systemd
    libexif pciutils
    liberation_ttf curl util-linux wget
    flac harfbuzz icu libpng opusWithCustomModes snappy speechd
    bzip2 libcap at-spi2-atk at-spi2-core
    libkrb5 libdrm libglvnd mesa coreutils
    libxkbcommon pipewire wayland
  ] ++ optional pulseSupport libpulseaudio
    ++ optional libvaSupport libva
    ++ [ gtk3 ];

  suffix = if channel != "stable" then "-" + channel else "";

  crashpadHandlerBinary = if lib.versionAtLeast version "94"
    then "chrome_crashpad_handler"
    else "crashpad_handler";

in stdenv.mkDerivation {
  inherit version;

  name = "google-chrome${suffix}-${version}";

  src = chromium.chromeSrc;

  nativeBuildInputs = [ patchelf makeWrapper ];
  buildInputs = [
    # needed for GSETTINGS_SCHEMAS_PATH
    gsettings-desktop-schemas glib gtk3

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
    runHook preInstall

    case ${channel} in
      beta) appname=chrome-beta      dist=beta     ;;
      dev)  appname=chrome-unstable  dist=unstable ;;
      *)    appname=chrome           dist=stable   ;;
    esac

    exe=$out/bin/google-chrome-$dist

    mkdir -p $out/bin $out/share

    cp -a opt/* $out/share
    cp -a usr/share/* $out/share


    substituteInPlace $out/share/google/$appname/google-$appname \
      --replace 'CHROME_WRAPPER' 'WRAPPER'
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
      --suffix PATH            : "${lib.makeBinPath [ xdg-utils ]}" \
      --prefix XDG_DATA_DIRS   : "$XDG_ICON_DIRS:$GSETTINGS_SCHEMAS_PATH:${addOpenGLRunpath.driverLink}/share" \
      --set CHROME_WRAPPER  "google-chrome-$dist" \
      --add-flags ${escapeShellArg commandLineArgs} \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland}}"

    for elf in $out/share/google/$appname/{chrome,chrome-sandbox,${crashpadHandlerBinary},nacl_helper}; do
      patchelf --set-rpath $rpath $elf
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $elf
    done

    runHook postInstall
  '';

  meta = {
    description = "A freeware web browser developed by Google";
    homepage = "https://www.google.com/chrome/browser/";
    license = licenses.unfree;
    sourceProvenance = with sourceTypes; [ binaryNativeCode ];
    maintainers = with maintainers; [ primeos ];
    # Note from primeos: By updating Chromium I also update Google Chrome and
    # will try to merge PRs and respond to issues but I'm not actually using
    # Google Chrome.
    platforms = [ "x86_64-linux" ];
    mainProgram =
      if (channel == "dev") then "google-chrome-unstable"
      else "google-chrome-${channel}";
  };
}

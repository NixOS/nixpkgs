{ lib, stdenv, patchelf, makeWrapper, fetchurl, writeScript

# Linked dynamic libraries.
, glib, fontconfig, freetype, pango, cairo, libX11, libXi, atk, nss, nspr
, libXcursor, libXext, libXfixes, libXrender, libXScrnSaver, libXcomposite, libxcb
, alsa-lib, libXdamage, libXtst, libXrandr, libxshmfence, expat, cups
, dbus, gtk3, gtk4, gdk-pixbuf, gcc-unwrapped, at-spi2-atk, at-spi2-core
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

# Necessary for USB audio devices.
, pulseSupport ? true, libpulseaudio

, gsettings-desktop-schemas
, gnome

# For video acceleration via VA-API (--enable-features=VaapiVideoDecoder)
, libvaSupport ? true, libva

# For Vulkan support (--enable-features=Vulkan)
, addOpenGLRunpath
}:

let
  opusWithCustomModes = libopus.override {
    withCustomModes = true;
  };

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
  ] ++ lib.optional pulseSupport libpulseaudio
    ++ lib.optional libvaSupport libva
    ++ [ gtk3 gtk4 ];

in stdenv.mkDerivation (finalAttrs: {
  pname = "google-chrome";
  version = "124.0.6367.201";

  src = fetchurl {
    url = "https://dl.google.com/linux/chrome/deb/pool/main/g/google-chrome-stable/google-chrome-stable_${finalAttrs.version}-1_amd64.deb";
    hash = "sha256-RvQdpDmWRcsASh1b8M0Zg+AvZprE5qhi14shfo0WlfE=";
  };

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

  rpath = lib.makeLibraryPath deps + ":" + lib.makeSearchPathOutput "lib" "lib64" deps;
  binpath = lib.makeBinPath deps;

  installPhase = ''
    runHook preInstall

    appname=chrome
    dist=stable

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
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    for elf in $out/share/google/$appname/{chrome,chrome-sandbox,chrome_crashpad_handler}; do
      patchelf --set-rpath $rpath $elf
      patchelf --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" $elf
    done

    runHook postInstall
  '';

  passthru = {
    updateScript = writeScript "update-google-chrome.sh" ''
      #!/usr/bin/env nix-shell
      #!nix-shell -i bash -p curl jq common-updater-scripts
      url="https://versionhistory.googleapis.com/v1/chrome/platforms/linux/channels/stable/versions/all/releases"
      response=$(curl --silent $url)
      version=$(jq ".releases[0].version" --raw-output <<< "$response")
      update-source-version ${finalAttrs.pname} "$version" --ignore-same-hash
    '';
  };

  meta = {
    description = "A freeware web browser developed by Google";
    homepage = "https://www.google.com/chrome/browser/";
    license = lib.licenses.unfree;
    sourceProvenance = with lib.sourceTypes; [ binaryNativeCode ];
    maintainers = with lib.maintainers; [ jnsgruk johnrtitor ];
    platforms = [ "x86_64-linux" ];
    mainProgram = "google-chrome-stable";
  };
})

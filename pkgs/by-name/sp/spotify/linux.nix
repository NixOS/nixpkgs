{
  fetchurl,
  lib,
  stdenv,
  squashfsTools,
  xorg,
  alsa-lib,
  makeShellWrapper,
  wrapGAppsHook3,
  openssl,
  freetype,
  glib,
  pango,
  cairo,
  atk,
  gdk-pixbuf,
  gtk3,
  cups,
  nspr,
  nss_latest,
  libpng,
  libnotify,
  libgcrypt,
  systemd,
  fontconfig,
  dbus,
  expat,
  ffmpeg_4,
  curlWithGnuTls,
  zlib,
  zenity,
  at-spi2-atk,
  at-spi2-core,
  libpulseaudio,
  libdrm,
  libgbm,
  libxkbcommon,
  pname,
  meta,
  harfbuzz,
  libayatana-appindicator,
  libdbusmenu,
  libGL,
  # High-DPI support: Spotify's --force-device-scale-factor argument
  # not added if `null`, otherwise, should be a number.
  deviceScaleFactor ? null,
}:

let
  # TO UPDATE: just execute the ./update.sh script (won't do anything if there is no update)
  # "rev" decides what is actually being downloaded
  # If an update breaks things, one of those might have valuable info:
  # https://aur.archlinux.org/packages/spotify/
  # https://community.spotify.com/t5/Desktop-Linux
  version = "1.2.48.405.gf2c48e6f";
  # To get the latest stable revision:
  # curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/spotify?channel=stable' | jq '.download_url,.version,.last_updated'
  # To get general information:
  # curl -H 'Snap-Device-Series: 16' 'https://api.snapcraft.io/v2/snaps/info/spotify' | jq '.'
  # More examples of api usage:
  # https://github.com/canonical-websites/snapcraft.io/blob/master/webapp/publisher/snaps/views.py
  rev = "80";

  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curlWithGnuTls
    dbus
    expat
    ffmpeg_4 # Requires libavcodec < 59 as of 1.2.9.743.g85d9593d
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    harfbuzz
    libayatana-appindicator
    libdbusmenu
    libdrm
    libgcrypt
    libGL
    libnotify
    libpng
    libpulseaudio
    libxkbcommon
    libgbm
    nss_latest
    pango
    stdenv.cc.cc
    systemd
    xorg.libICE
    xorg.libSM
    xorg.libX11
    xorg.libxcb
    xorg.libXcomposite
    xorg.libXcursor
    xorg.libXdamage
    xorg.libXext
    xorg.libXfixes
    xorg.libXi
    xorg.libXrandr
    xorg.libXrender
    xorg.libXScrnSaver
    xorg.libxshmfence
    xorg.libXtst
    zlib
  ];

in

stdenv.mkDerivation {
  inherit pname version;

  # fetch from snapcraft instead of the debian repository most repos fetch from.
  # That is a bit more cumbersome. But the debian repository only keeps the last
  # two versions, while snapcraft should provide versions indefinitely:
  # https://forum.snapcraft.io/t/how-can-a-developer-remove-her-his-app-from-snap-store/512

  # This is the next-best thing, since we're not allowed to re-distribute
  # spotify ourselves:
  # https://community.spotify.com/t5/Desktop-Linux/Redistribute-Spotify-on-Linux-Distributions/td-p/1695334
  src = fetchurl {
    name = "spotify-${version}-${rev}.snap";
    url = "https://api.snapcraft.io/api/v1/snaps/download/pOBIoZ2LrCB3rDohMxoYGnbN14EHOgD7_${rev}.snap";
    hash = "sha512-Ej9SEhZhssQiH1srcgUW5lQuUNg+htudV7mcnK6o0pW5PiBYZ6qOPEIZ/1tZzD9xkUJ8hCq08fJMB8NQ12KXMg==";
  };

  nativeBuildInputs = [
    wrapGAppsHook3
    makeShellWrapper
    squashfsTools
  ];

  dontStrip = true;
  dontPatchELF = true;

  unpackPhase = ''
    runHook preUnpack
    unsquashfs "$src" '/usr/share/spotify' '/usr/bin/spotify' '/meta/snap.yaml'
    cd squashfs-root
    if ! grep -q 'grade: stable' meta/snap.yaml; then
      # Unfortunately this check is not reliable: At the moment (2018-07-26) the
      # latest version in the "edge" channel is also marked as stable.
      echo "The snap package is marked as unstable:"
      grep 'grade: ' meta/snap.yaml
      echo "You probably chose the wrong revision."
      exit 1
    fi
    if ! grep -q '${version}' meta/snap.yaml; then
      echo "Package version differs from version found in snap metadata:"
      grep 'version: ' meta/snap.yaml
      echo "While the nix package specifies: ${version}."
      echo "You probably chose the wrong revision or forgot to update the nix version."
      exit 1
    fi
    runHook postUnpack
  '';

  # Prevent double wrapping
  dontWrapGApps = true;

  env = rec {
    libdir = "${placeholder "out"}/lib/spotify";
    librarypath = "${lib.makeLibraryPath deps}:${libdir}";
  };

  installPhase = ''
    runHook preInstall

    mkdir -p $libdir
    mv ./usr/* $out/

    # Work around Spotify referring to a specific minor version of
    # OpenSSL.

    ln -s ${lib.getLib openssl}/lib/libssl.so $libdir/libssl.so.1.0.0
    ln -s ${lib.getLib openssl}/lib/libcrypto.so $libdir/libcrypto.so.1.0.0
    ln -s ${nspr.out}/lib/libnspr4.so $libdir/libnspr4.so
    ln -s ${nspr.out}/lib/libplc4.so $libdir/libplc4.so

    ln -s ${ffmpeg_4.lib}/lib/libavcodec.so* $libdir
    ln -s ${ffmpeg_4.lib}/lib/libavformat.so* $libdir

    rpath="$out/share/spotify:$libdir"

    chmod +w "$out/share/spotify/spotify"
    patchelf \
      --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath $rpath $out/share/spotify/spotify

    # fix Icon line in the desktop file (#48062)
    sed -i "s:^Icon=.*:Icon=spotify-client:" "$out/share/spotify/spotify.desktop"

    # Desktop file
    mkdir -p "$out/share/applications/"
    cp "$out/share/spotify/spotify.desktop" "$out/share/applications/"

    # Icons
    for i in 16 22 24 32 48 64 128 256 512; do
      ixi="$i"x"$i"
      mkdir -p "$out/share/icons/hicolor/$ixi/apps"
      ln -s "$out/share/spotify/icons/spotify-linux-$i.png" \
        "$out/share/icons/hicolor/$ixi/apps/spotify-client.png"
    done

    runHook postInstall
  '';

  fixupPhase = ''
    runHook preFixup

    wrapProgramShell $out/share/spotify/spotify \
      ''${gappsWrapperArgs[@]} \
      ${
        lib.optionalString (deviceScaleFactor != null) ''
          --add-flags "--force-device-scale-factor=${toString deviceScaleFactor}" \
        ''
      } \
      --prefix LD_LIBRARY_PATH : "$librarypath" \
      --prefix PATH : "${zenity}/bin" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--enable-features=UseOzonePlatform --ozone-platform=wayland --enable-wayland-ime=true}}"

    runHook postFixup
  '';

  meta = meta // {
    maintainers = with lib.maintainers; [
      ftrvxmtrx
      sheenobu
      timokau
      ma27
    ];
  };
}

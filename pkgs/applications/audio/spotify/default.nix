{ fetchurl, lib, stdenv, squashfsTools, xorg, alsa-lib, makeWrapper, wrapGAppsHook, openssl, freetype
, glib, pango, cairo, atk, gdk-pixbuf, gtk3, cups, nspr, nss, libpng, libnotify
, libgcrypt, systemd, fontconfig, dbus, expat, ffmpeg, curl, zlib, gnome
, at-spi2-atk, at-spi2-core, libpulseaudio, libdrm, mesa, libxkbcommon
}:

let
  # TO UPDATE: just execute the ./update.sh script (won't do anything if there is no update)
  # "rev" decides what is actually being downloaded
  # If an update breaks things, one of those might have valuable info:
  # https://aur.archlinux.org/packages/spotify/
  # https://community.spotify.com/t5/Desktop-Linux
  version = "1.1.68.632.g2b11de83";
  # To get the latest stable revision:
  # curl -H 'X-Ubuntu-Series: 16' 'https://api.snapcraft.io/api/v1/snaps/details/spotify?channel=stable' | jq '.download_url,.version,.last_updated'
  # To get general information:
  # curl -H 'Snap-Device-Series: 16' 'https://api.snapcraft.io/v2/snaps/info/spotify' | jq '.'
  # More examples of api usage:
  # https://github.com/canonical-websites/snapcraft.io/blob/master/webapp/publisher/snaps/views.py
  rev = "53";

  deps = [
    alsa-lib
    at-spi2-atk
    at-spi2-core
    atk
    cairo
    cups
    curl
    dbus
    expat
    ffmpeg
    fontconfig
    freetype
    gdk-pixbuf
    glib
    gtk3
    libdrm
    libgcrypt
    libnotify
    libpng
    libpulseaudio
    libxkbcommon
    mesa
    nss
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
  pname = "spotify-unwrapped";
  inherit version;

  # fetch from snapcraft instead of the debian repository most repos fetch from.
  # That is a bit more cumbersome. But the debian repository only keeps the last
  # two versions, while snapcraft should provide versions indefinately:
  # https://forum.snapcraft.io/t/how-can-a-developer-remove-her-his-app-from-snap-store/512

  # This is the next-best thing, since we're not allowed to re-distribute
  # spotify ourselves:
  # https://community.spotify.com/t5/Desktop-Linux/Redistribute-Spotify-on-Linux-Distributions/td-p/1695334
  src = fetchurl {
    url = "https://api.snapcraft.io/api/v1/snaps/download/pOBIoZ2LrCB3rDohMxoYGnbN14EHOgD7_${rev}.snap";
    sha512 = "ed991691c99fe97ed9ff5d0f5cc9a8883c176fa3b3054293c37d545abbb895c6260afdf1c8c0828d62c36ea7ab384e166b6151effb4614c93e4fa712319a08a3";
  };

  nativeBuildInputs = [ makeWrapper wrapGAppsHook squashfsTools ];

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

  installPhase =
    ''
      runHook preInstall

      libdir=$out/lib/spotify
      mkdir -p $libdir
      mv ./usr/* $out/

      cp meta/snap.yaml $out

      # Work around Spotify referring to a specific minor version of
      # OpenSSL.

      ln -s ${openssl.out}/lib/libssl.so $libdir/libssl.so.1.0.0
      ln -s ${openssl.out}/lib/libcrypto.so $libdir/libcrypto.so.1.0.0
      ln -s ${nspr.out}/lib/libnspr4.so $libdir/libnspr4.so
      ln -s ${nspr.out}/lib/libplc4.so $libdir/libplc4.so

      ln -s ${ffmpeg.out}/lib/libavcodec.so* $libdir
      ln -s ${ffmpeg.out}/lib/libavformat.so* $libdir

      rpath="$out/share/spotify:$libdir"

      patchelf \
        --interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
        --set-rpath $rpath $out/share/spotify/spotify

      librarypath="${lib.makeLibraryPath deps}:$libdir"
      wrapProgram $out/share/spotify/spotify \
        ''${gappsWrapperArgs[@]} \
        --prefix LD_LIBRARY_PATH : "$librarypath" \
        --prefix PATH : "${gnome.zenity}/bin"

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

  meta = with lib; {
    homepage = "https://www.spotify.com/";
    description = "Play music from the Spotify music service";
    license = licenses.unfree;
    maintainers = with maintainers; [ eelco ftrvxmtrx sheenobu mudri timokau ma27 ];
    platforms = [ "x86_64-linux" ];
  };
}

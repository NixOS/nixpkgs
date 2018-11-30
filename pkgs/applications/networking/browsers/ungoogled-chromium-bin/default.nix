{ stdenv, lib, fetchurl

# default dependencies
, bzip2, flac, speex, libopus
, libevent, expat, libjpeg, snappy
, libpng, libcap
, xdg_utils, yasm, minizip, libwebp
, libusb1, pciutils, nss, re2, zlib

, nspr, systemd, kerberos
, utillinux, alsaLib
, bison, gperf
, glib, gtk2, gtk3, dbus-glib
, libXScrnSaver, libXcursor, libXtst, libGLU_combined
, protobuf, speechd, libXdamage, cups
, ffmpeg, libxslt, libxml2, at-spi2-core
, jdk
, xorg, gcc-unwrapped
, libX11, libXcomposite, libXext, libXfixes, libXi, libXrender
, dbus, pango, cairo, atk, gdk_pixbuf, libXrandr, at-spi2-atk
}:

let rpath = lib.makeLibraryPath [
    bzip2 flac speex libopus
    libevent expat libjpeg snappy
    libpng libcap
    xdg_utils yasm minizip libwebp
    libusb1 pciutils nss re2 zlib

    nspr systemd kerberos
    utillinux alsaLib
    bison gperf
    glib gtk2 gtk3 dbus-glib
    libXScrnSaver libXcursor libXtst libGLU_combined
    protobuf speechd libXdamage cups
    ffmpeg libxslt libxml2 at-spi2-core
    jdk
    gcc-unwrapped.lib libX11 xorg.libxcb libXcomposite libXext
    libXfixes libXi libXrender dbus pango cairo atk gdk_pixbuf
    libXrandr at-spi2-atk
];

# Based on https://aur.archlinux.org/cgit/aur.git/tree/PKGBUILD?h=ungoogled-chromium-bin
in stdenv.mkDerivation rec {
    name = "ungoogled-chromium-${version}";
    version = "70.0.3538.110";
    _url_id = "6oST9BpB92Lcdtj";
    pkgrel = "1";

    src = fetchurl {
        url = "https://cloud.woelkli.com/s/${_url_id}/download";
        sha256 = "1j2x98s9c4yvs5j1n3gwwjwsa2mmfwn4z52rci8fr4x0a824dafd";
    };

    dontConfigure = true;
    dontBuild = true;
    dontPatchELF = true;

    unpackPhase = "tar xf $src";

    installPhase = ''
      cp -R ungoogled-chromium_${version}-${pkgrel}_linux $out

      # TODO move *.pak, resources/, *.so, icudtl.dat
      # to $out/usr/lib/chromium

      patchelf \
           --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
           --set-rpath "${rpath}" $out/chrome

      mkdir -p $out/bin
      ln -sf $out/chrome-wrapper $out/bin/chromium-ungoogled

      # TODO the $src does not provide a .desktop file
      # This needs to be downloaded separately from AUR

      # Icon
      export icon=48
      mkdir -p $out/share/icons/hicolor/$icon\x$icon/apps
      ln -s $out/product_logo_$icon.png $out/share/icons/hicolor/$icon\x$icon/apps/chromium.png
    '';

    meta = with stdenv.lib; {
      homepage = "https://github.com/Eloston/ungoogled-chromium";
      description = "Google Chromium, sans integration with Google";
      longDescription = ''
        ungoogled-chromium is Google Chromium, sans integration with Google. It also features some tweaks to enhance privacy, control, and transparency (almost all of which require manual activation or enabling).
        ungoogled-chromium retains the default Chromium experience as closely as possible. Unlike other Chromium forks that have their own visions of a web browser, ungoogled-chromium is essentially a drop-in replacement for Chromium.
      '';
      license = licenses.bsd3;
      maintainers = [ maintainers.rht ];
      platforms = [ "x86_64-linux" ];
    };
}

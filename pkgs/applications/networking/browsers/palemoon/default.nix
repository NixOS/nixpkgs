{ stdenv, fetchFromGitHub, makeDesktopItem
, pkgconfig, autoconf213, alsaLib, bzip2, cairo
, dbus, dbus-glib, file, fontconfig, freetype
, gstreamer, gst-plugins-base, gst_all_1
, gtk2, hunspell, icu, libevent, libjpeg, libnotify
, libstartup_notification, libvpx, makeWrapper, libGLU_combined
, nspr, nss, pango, perl, python, libpulseaudio, sqlite
, unzip, xorg, which, yasm, zip, zlib
}:

stdenv.mkDerivation rec {
  name = "palemoon-${version}";
  version = "27.9.4";

  src = fetchFromGitHub {
    name   = "palemoon-src";
    owner  = "MoonchildProductions";
    repo   = "Pale-Moon";
    rev    = version + "_Release";
    sha256 = "0ir5gzhw98gfn15x58g1fwi11jd7gysvacqxg1v0jdjhgdl4m5sx";
  };

  desktopItem = makeDesktopItem {
    name = "palemoon";
    exec = "palemoon %U";
    icon = "palemoon";
    desktopName = "Pale Moon";
    genericName = "Web Browser";
    categories = "Application;Network;WebBrowser;";
    mimeType = stdenv.lib.concatStringsSep ";" [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
    ];
  };

  buildInputs = [
    alsaLib bzip2 cairo dbus dbus-glib file fontconfig freetype
    gst-plugins-base gstreamer gst_all_1.gst-plugins-base gtk2
    hunspell icu libevent libjpeg libnotify libstartup_notification
    libvpx makeWrapper libGLU_combined nspr nss pango perl pkgconfig python
    libpulseaudio sqlite unzip which yasm zip zlib
  ] ++ (with xorg; [
    libX11 libXext libXft libXi libXrender libXScrnSaver
    libXt pixman xorgproto
  ]);

  enableParallelBuilding = true;

  configurePhase = ''
    export AUTOCONF=${autoconf213}/bin/autoconf
    export MOZBUILD_STATE_PATH=$(pwd)/.mozbuild
    export MOZ_CONFIG=$(pwd)/.mozconfig
    export builddir=$(pwd)/build
    mkdir -p $MOZBUILD_STATE_PATH $builddir
    echo > $MOZ_CONFIG "
    . $src/build/mozconfig.common
    ac_add_options --prefix=$out
    ac_add_options --with-pthreads
    ac_add_options --enable-application=browser
    ac_add_options --enable-official-branding
    ac_add_options --enable-optimize="-O2"
    ac_add_options --enable-release
    ac_add_options --enable-devtools
    ac_add_options --enable-jemalloc
    ac_add_options --enable-shared-js
    ac_add_options --enable-strip
    ac_add_options --disable-tests
    ac_add_options --disable-installer
    ac_add_options --disable-updaters
    "
  '';

  patchPhase = ''
    chmod u+w .
  '';

  hardeningDisable = [ "format" ];
  
  buildPhase = ''
    cd $builddir
    $src/mach build
  '';

  installPhase = ''
    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications

    for n in 16 22 24 32 48 256; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      cp $src/browser/branding/official/default$n.png \
         $out/share/icons/hicolor/$size/apps/palemoon.png
    done

    cd $builddir
    $src/mach install
  '';

  meta = with stdenv.lib; {
    description = "A web browser";
    longDescription = ''
      Pale Moon is an Open Source, Goanna-based web browser focusing on
      efficiency and customization.

      Pale Moon offers you a browsing experience in a browser completely built
      from its own, independently developed source that has been forked off from
      Firefox/Mozilla code a number of years ago, with carefully selected
      features and optimizations to improve the browser's stability and user
      experience, while offering full customization and a growing collection of
      extensions and themes to make the browser truly your own.
    '';
    homepage    = https://www.palemoon.org/;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ rnhmjoj AndersonTorres ];
    platforms   = platforms.linux;
  };
}

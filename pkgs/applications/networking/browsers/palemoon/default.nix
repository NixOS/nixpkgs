{ stdenv, fetchFromGitHub, makeDesktopItem
, pkgconfig, autoconf213, alsaLib, bzip2, cairo
, dbus, dbus_glib, file, fontconfig, freetype
, gstreamer, gst-plugins-base, gst_all_1
, gtk2, hunspell, icu, libevent, libjpeg, libnotify
, libstartup_notification, libvpx, makeWrapper, mesa 
, nspr, nss, pango, perl, python, libpulseaudio, sqlite 
, unzip, xlibs, which, yasm, zip, zlib
}:

stdenv.mkDerivation rec {
  name = "palemoon-${version}";
  version = "27.1.1";

  src = fetchFromGitHub {
    name   = "palemoon-src";
    owner  = "MoonchildProductions";
    repo   = "Pale-Moon";
    rev    = "a35936746069e6591181eb67e5f9ea094938bae5";
    sha256 = "0hns5993dh93brwz3z4xp1zp8n90x1hajxylv17zybpysax64jsk";
  };

  desktopItem = makeDesktopItem {
    name = "palemoon";
    exec = "palemoon %U";
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
    alsaLib bzip2 cairo dbus dbus_glib file fontconfig freetype
    gst-plugins-base gstreamer gst_all_1.gst-plugins-base gtk2
    hunspell icu libevent libjpeg libnotify libstartup_notification
    libvpx makeWrapper mesa nspr nss pango perl pkgconfig python
    libpulseaudio sqlite unzip which yasm zip zlib
  ] ++ (with xlibs; [
    libX11 libXext libXft libXi libXrender libXScrnSaver
    libXt pixman scrnsaverproto xextproto
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
    ac_add_options --enable-application=browser
    ac_add_options --enable-official-branding
    ac_add_options --enable-optimize="-O2"
    ac_add_options --enable-jemalloc
    ac_add_options --enable-shared-js
    ac_add_options --disable-tests
    "
  '';

  patchPhase = ''
    chmod u+w .
    sed -i /status4evar/d browser/installer/package-manifest.in
  '';

  buildPhase = ''
    cd $builddir
    $src/mach build
  '';

  installPhase = ''
    cd $builddir
    $src/mach install
  '';

  meta = with stdenv.lib; {
    description = "A web browser";
    homepage    = https://www.palemoon.org/;
    license     = licenses.mpl20;
    maintainers = with maintainers; [ rnhmjoj ];
    platforms   = platforms.linux;
  };

}

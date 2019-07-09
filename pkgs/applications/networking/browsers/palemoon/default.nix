{ stdenv, fetchFromGitHub, makeDesktopItem
, pkgconfig, autoconf213, alsaLib, bzip2, cairo
, dbus, dbus-glib, file, fontconfig, freetype
, gnome2, gnum4, gstreamer, gst-plugins-base, gst_all_1
, gtk2, hunspell, icu, libevent, libjpeg, libnotify
, libstartup_notification, libvpx, makeWrapper, libGLU_combined
, nspr, nss, pango, perl, python, libpulseaudio, sqlite
, unzip, xorg, wget, which, yasm, zip, zlib
}:

stdenv.mkDerivation rec {
  pname = "palemoon";
  version = "28.6.0.1";

  src = fetchFromGitHub {
    name   = "${pname}-${version}";
    owner  = "MoonchildProductions";
    repo   = "UXP";
    rev    = "PM${version}_Release";
    sha256 = "1adgajy5vsghvjlv2nqyrbp6mnv3k6slqxxi8r949xlb5h6d210b";
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
    gnome2.GConf gnum4 gst-plugins-base gstreamer gst_all_1.gst-plugins-base gtk2
    hunspell icu libevent libjpeg libnotify libstartup_notification
    libvpx makeWrapper libGLU_combined nspr nss pango perl pkgconfig python
    libpulseaudio sqlite unzip wget which yasm zip zlib
  ] ++ (with xorg; [
    libX11 libXext libXft libXi libXrender libXScrnSaver
    libXt pixman xorgproto
  ]);

  enableParallelBuilding = true;

  configurePhase = ''
    export MOZBUILD_STATE_PATH=$(pwd)/mozbuild
    export MOZCONFIG=$(pwd)/mozconfig
    export builddir=$(pwd)/pmbuild

    echo > $MOZCONFIG "
    mk_add_options AUTOCLOBBER=1
    mk_add_options MOZ_OBJDIR=$builddir
    ac_add_options --enable-application=palemoon

    ac_add_options --enable-optimize='-O2'

    # Please see https://www.palemoon.org/redist.shtml for restrictions when using the official branding.
    ac_add_options --enable-official-branding
    export MOZILLA_OFFICIAL=1

    ac_add_options --enable-default-toolkit=cairo-gtk2
    ac_add_options --enable-jemalloc
    ac_add_options --enable-strip
    ac_add_options --with-pthreads

    ac_add_options --disable-tests
    ac_add_options --disable-eme
    ac_add_options --disable-parental-controls
    ac_add_options --disable-accessibility
    ac_add_options --disable-webrtc
    ac_add_options --disable-gamepad
    ac_add_options --disable-necko-wifi
    ac_add_options --disable-updater

    ac_add_options --x-libraries=${xorg.libX11.out}/lib

    ac_add_options --prefix=$out
    mk_add_options MOZ_MAKE_FLAGS='-j$NIX_BUILD_CORES'
    mk_add_options AUTOCONF=${autoconf213}/bin/autoconf
    "
  '';

  hardeningDisable = [ "format" ];

  buildPhase = ''
    $src/mach build
  '';

  installPhase = ''
    $src/mach install

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications

    for n in 16 22 24 32 48 256; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      cp $src/application/palemoon/branding/official/default$n.png \
         $out/share/icons/hicolor/$size/apps/palemoon.png
    done
  '';

  meta = with stdenv.lib; {
    description = "An Open Source, Goanna-based web browser focusing on efficiency and customization";
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
    homepage    = "https://www.palemoon.org/";
    license     = licenses.mpl20;
    maintainers = with maintainers; [ rnhmjoj AndersonTorres OPNA2608 ];
    platforms   = platforms.linux;
  };
}

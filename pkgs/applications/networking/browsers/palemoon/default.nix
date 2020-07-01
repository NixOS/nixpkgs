{ stdenv, lib, fetchgit, makeDesktopItem
, pkgconfig, autoconf213, alsaLib, bzip2, cairo
, dbus, dbus-glib, ffmpeg_3, file, fontconfig, freetype
, gnome2, gnum4, gtk2, hunspell, libevent, libjpeg
, libnotify, libstartup_notification, makeWrapper
, libGLU, libGL, perl, python2, libpulseaudio
, unzip, xorg, wget, which, yasm, zip, zlib

, withGTK3 ? false, gtk3
}:

let

  libPath = lib.makeLibraryPath [ ffmpeg_3 ];
  gtkVersion = if withGTK3 then "3" else "2";

in stdenv.mkDerivation rec {
  pname = "palemoon";
  version = "28.10.0";

  src = fetchgit {
    url = "https://github.com/MoonchildProductions/Pale-Moon.git";
    rev = "${version}_Release";
    sha256 = "0c64vmrp46sbl1dgl9dq2vkmpgz9gvgd59dk02jqwyhx4lln1g2l";
    fetchSubmodules = true;
  };

  desktopItem = makeDesktopItem {
    name = "palemoon";
    exec = "palemoon %U";
    icon = "palemoon";
    desktopName = "Pale Moon";
    genericName = "Web Browser";
    categories = "Network;WebBrowser;";
    mimeType = lib.concatStringsSep ";" [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
      "x-scheme-handler/ftp"
    ];
  };

  nativeBuildInputs = [
    file gnum4 makeWrapper perl pkgconfig python2 wget which
  ];

  buildInputs = [
    alsaLib bzip2 cairo dbus dbus-glib ffmpeg_3 fontconfig freetype
    gnome2.GConf gtk2 hunspell libevent libjpeg libnotify
    libstartup_notification libGLU libGL
    libpulseaudio unzip yasm zip zlib
  ]
  ++ (with xorg; [
    libX11 libXext libXft libXi libXrender libXScrnSaver
    libXt pixman xorgproto
  ])
  ++ lib.optional withGTK3 gtk3;

  enableParallelBuilding = true;

  configurePhase = ''
    export MOZCONFIG=$(pwd)/mozconfig
    export MOZ_NOSPAM=1

    # Keep this similar to the official .mozconfig file,
    # only minor changes for portability are permitted with branding.
    # https://developer.palemoon.org/build/linux/
    echo > $MOZCONFIG '
    # Clear this if not a 64bit build
    _BUILD_64=${lib.optionalString stdenv.hostPlatform.is64bit "1"}

    # Set GTK Version to 2 or 3
    _GTK_VERSION=${gtkVersion}

    # Standard build options for Pale Moon
    ac_add_options --enable-application=palemoon
    ac_add_options --enable-optimize="-O2 -w"
    ac_add_options --enable-default-toolkit=cairo-gtk$_GTK_VERSION
    ac_add_options --enable-jemalloc
    ac_add_options --enable-strip
    ac_add_options --enable-devtools

    ac_add_options --disable-eme
    ac_add_options --disable-webrtc
    ac_add_options --disable-gamepad
    ac_add_options --disable-tests
    ac_add_options --disable-debug
    ac_add_options --disable-necko-wifi
    ac_add_options --disable-updater
    ac_add_options --with-pthreads

    # Please see https://www.palemoon.org/redist.shtml for restrictions when using the official branding.
    ac_add_options --enable-official-branding
    export MOZILLA_OFFICIAL=1

    ac_add_options --x-libraries=${lib.makeLibraryPath [ xorg.libX11 ]}

    export MOZ_PKG_SPECIAL=gtk$_GTK_VERSION

    #
    # NixOS-specific adjustments
    #

    ac_add_options --prefix=$out

    mk_add_options MOZ_MAKE_FLAGS="-j$NIX_BUILD_CORES"
    mk_add_options AUTOCONF=${autoconf213}/bin/autoconf
    '
  '';

  buildPhase = "$src/mach build";

  installPhase = ''
    $src/mach install

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications

    for n in 16 22 24 32 48 256; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      cp $src/palemoon/branding/official/default$n.png \
         $out/share/icons/hicolor/$size/apps/palemoon.png
    done

    wrapProgram $out/lib/palemoon-${version}/palemoon \
      --prefix LD_LIBRARY_PATH : "${libPath}"
  '';

  meta = with lib; {
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
    maintainers = with maintainers; [ AndersonTorres OPNA2608 ];
    platforms   = [ "i686-linux" "x86_64-linux" ];
  };
}

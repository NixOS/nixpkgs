{ stdenv, lib, fetchgit, makeDesktopItem, pkg-config, makeWrapper
# Build
, python2, autoconf213, yasm, perl
, unzip, gnome2, gnum4

# Runtime
, xorg, zip, freetype, fontconfig, glibc, libffi
, dbus, dbus-glib, gtk2, alsa-lib, jack2, ffmpeg
}:

let

  libPath = lib.makeLibraryPath [ ffmpeg ];

in stdenv.mkDerivation rec {
  pname = "webbrowser";
  version = "29.0.0rc1";

  src = fetchgit {
    url = "https://git.nuegia.net/webbrowser.git";
    rev = version;
    sha256 = "1d82943mla6q3257081d946kgms91dg0n93va3zlzm9hbbqilzm6";
    fetchSubmodules = true;
  };

  desktopItem = makeDesktopItem {
    name = "webbrowser";
    exec = "webbrowser %U";
    icon = "webbrowser";
    desktopName = "Web Browser";
    genericName = "Web Browser";
    categories = [ "Network" "WebBrowser" ];
    mimeTypes = [
      "text/html"
      "text/xml"
      "application/xhtml+xml"
      "application/vnd.mozilla.xul+xml"
      "x-scheme-handler/http"
      "x-scheme-handler/https"
    ];
  };

  nativeBuildInputs = [
    gnum4 makeWrapper perl pkg-config python2 unzip
  ];

  buildInputs = [
    alsa-lib dbus dbus-glib ffmpeg fontconfig freetype yasm zip jack2 gtk2
    gnome2.GConf xorg.libXt
  ];

  enableParallelBuilding = true;

  configurePhase = ''
    export MOZCONFIG=$PWD/.mozconfig
    export MOZ_NOSPAM=1

    cp $src/doc/mozconfig.example $MOZCONFIG
    # Need to modify it
    chmod 644 $MOZCONFIG

    substituteInPlace $MOZCONFIG \
      --replace "mk_add_options PYTHON=/usr/bin/python2" "mk_add_options PYTHON=${python2}/bin/python2" \
      --replace "mk_add_options AUTOCONF=/usr/bin/autoconf-2.13" "mk_add_options AUTOCONF=${autoconf213}/bin/autoconf" \
      --replace 'mk_add_options MOZ_OBJDIR=$HOME/build/wbobjects/' "" \
      --replace "ac_add_options --x-libraries=/usr/lib64" "ac_add_options --x-libraries=${lib.makeLibraryPath [ xorg.libX11 ]}" \
      --replace "_BUILD_64=1" "_BUILD_64=${lib.optionalString stdenv.hostPlatform.is64bit "1"}" \
      --replace "--enable-ccache" "--disable-ccache"

    echo >> $MOZCONFIG '
    #
    # NixOS-specific adjustments
    #

    ac_add_options --prefix=$out

    mk_add_options MOZ_MAKE_FLAGS="-j$NIX_BUILD_CORES"
    '
  '';

  buildPhase = "$src/mach build";

  installPhase = ''
    $src/mach install

    mkdir -p $out/share/applications
    cp ${desktopItem}/share/applications/* $out/share/applications

    for n in 16 32 48; do
      size=$n"x"$n
      mkdir -p $out/share/icons/hicolor/$size/apps
      cp $src/webbrowser/branding/unofficial/default$n.png \
         $out/share/icons/hicolor/$size/apps/webbrowser.png
    done

    # Needed to make videos work
    wrapProgram $out/lib/webbrowser-${version}/webbrowser \
      --prefix LD_LIBRARY_PATH : "${libPath}"
  '';

  meta = with lib; {
    description = "Generic web browser without trackers compatible with XUL plugins using UXP rendering engine";
    homepage    = "https://git.nuegia.net/webbrowser.git/";
    license     = [ licenses.mpl20 licenses.gpl3 ];
    maintainers = with maintainers; [ TheBrainScrambler ];
    platforms   = [ "i686-linux" "x86_64-linux" ];
    broken      = true; # 2021-01-07
  };
}

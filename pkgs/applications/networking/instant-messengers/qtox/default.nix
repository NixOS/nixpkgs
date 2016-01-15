{ stdenv, fetchgit, pkgconfig, libtoxcore-dev, openal, opencv,
  libsodium, libXScrnSaver, glib, gdk_pixbuf, gtk2, cairo,
  pango, atk, qrencode, ffmpeg, filter-audio, makeWrapper,
  qtbase, qtsvg, qttools, qttranslations, sqlcipher }:

let
  revision = "8b671916abdcc1d553a367a502b23ec4ea7568a1";
in

stdenv.mkDerivation rec {
  name = "qtox-dev-20151221";

  src = fetchgit {
      url = "https://github.com/tux3/qTox.git";
      rev = "${revision}";
      md5 = "a93a63d35e506be4b21abda0986f19e7";
  };

  buildInputs =
    [
      libtoxcore-dev openal opencv libsodium filter-audio
      qtbase qttools qtsvg libXScrnSaver glib gtk2 cairo
      pango atk qrencode ffmpeg qttranslations makeWrapper
      sqlcipher
    ];

  nativeBuildInputs = [ pkgconfig ];

  preConfigure = ''
    # patch .pro file for proper set of the git hash
    sed -i '/git rev-parse/d' qtox.pro
    sed -i 's/$$quote($$GIT_VERSION)/${revision}/' qtox.pro
    # since .pro have hardcoded paths, we need to explicitly set paths here
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags glib-2.0)"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gdk-pixbuf-2.0)"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags gtk+-2.0)"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags cairo)"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags pango)"
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags atk)"
  '';

  configurePhase = ''
    runHook preConfigure
    qmake
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp qtox $out/bin
    wrapProgram $out/bin/qtox \
      --prefix QT_PLUGIN_PATH : ${qtsvg}/lib/qt5/plugins
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Qt Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric jgeerds akaWolf ];
    platforms = platforms.all;
  };
}

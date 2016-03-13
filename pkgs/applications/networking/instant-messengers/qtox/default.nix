{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore-dev, openal, opencv,
  libsodium, libXScrnSaver, glib, gdk_pixbuf, gtk2, cairo,
  pango, atk, qrencode, ffmpeg, filter-audio, makeWrapper,
  qtbase, qtsvg, qttools, qttranslations, sqlcipher }:

let
  version = "1.3.0";
  revision = "v${version}";
in

stdenv.mkDerivation rec {
  name = "qtox-${version}";

  src = fetchFromGitHub {
      owner = "tux3";
      repo = "qTox";
      rev = revision;
      sha256 = "0z2rxsa23vpl4q0h63mybw7kv8n1sm6nwb93l0cc046a3n9axid8";
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
    export NIX_CFLAGS_COMPILE="$NIX_CFLAGS_COMPILE $(pkg-config --cflags sqlcipher)"
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

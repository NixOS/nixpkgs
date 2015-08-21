{ stdenv, fetchgit, pkgconfig, libtoxcore-dev, qt5, openal, opencv,
  libsodium, libXScrnSaver, glib, gdk_pixbuf, gtk2, cairo,
  pango, atk, qrencode, ffmpeg, filter-audio, makeWrapper }:

stdenv.mkDerivation rec {
  name = "qtox-dev-20150821";

  src = fetchgit {
      url = "https://github.com/tux3/qTox.git";
      rev = "2f6b5e052f2a625d506e83f880c5d68b49118f95";
      md5 = "b2f9cf283136b6e558876ca2e6d128a3";
  };

  buildInputs =
    [
      libtoxcore-dev openal opencv libsodium filter-audio
      qt5.base qt5.tools libXScrnSaver glib gtk2 cairo
      pango atk qrencode ffmpeg qt5.translations makeWrapper
    ];

  nativeBuildInputs = [ pkgconfig ];

  preConfigure = ''
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
      --prefix QT_PLUGIN_PATH : ${qt5.svg}/lib/qt5/plugins
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "QT Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric jgeerds ];
    platforms = platforms.all;
  };
}

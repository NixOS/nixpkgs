{ stdenv, fetchgit, pkgconfig, libtoxcore-dev, qt5, openal, opencv,
  libsodium, libXScrnSaver, glib, gdk_pixbuf, gtk2, cairo,
  pango, atk, qrencode, ffmpeg, filter-audio }:

stdenv.mkDerivation rec {
  name = "qtox-dev-20150624";

  src = fetchgit {
      url = "https://github.com/tux3/qTox.git";
      rev = "9f386135a2cf428d2802b158c70be4beee5abf86";
      sha256 = "1m2y50q5yim1q75k48cy5daq5qm77cvb3kcla7lpqv54xnfdwxk8";
  };

  buildInputs =
    [
      libtoxcore-dev openal opencv libsodium filter-audio
      qt5.base qt5.tools libXScrnSaver glib gtk2 cairo
      pango atk qrencode ffmpeg qt5.translations
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
  '';

  meta = with stdenv.lib; {
    description = "QT Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric jgeerds ];
    platforms = platforms.all;
  };
}


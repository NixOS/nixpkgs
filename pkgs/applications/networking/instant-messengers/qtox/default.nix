{ stdenv, fetchFromGitHub, cmake, pkgconfig, openal, opencv,
  libtoxcore, libsodium, libXScrnSaver, glib, gdk_pixbuf, gtk2, cairo, xorg,
  pango, atk, qrencode, ffmpeg, filter-audio, makeQtWrapper,
  qtbase, qtsvg, qttools, qttranslations, sqlcipher,
  libvpx, libopus }:

stdenv.mkDerivation rec {
  name = "qtox-${version}";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner  = "tux3";
    repo   = "qTox";
    rev    = "v${version}";
    sha256 = "073kwfaw5n7vvcpwrpdbw5mlswbbwjipx7yy4a95r9z0gjljqnhq";
  };

  buildInputs = [
    libtoxcore openal opencv libsodium filter-audio
    qtbase qttools qtsvg libXScrnSaver glib gtk2 cairo
    pango atk qrencode ffmpeg qttranslations
    sqlcipher
    libopus libvpx
  ] ++ (with xorg; [
    libpthreadstubs libXdmcp
  ]);

  nativeBuildInputs = [ cmake makeQtWrapper pkgconfig ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
    cp qtox $out/bin
    wrapQtProgram $out/bin/qtox

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Qt Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric jgeerds akaWolf ];
    platforms = platforms.all;
  };
}

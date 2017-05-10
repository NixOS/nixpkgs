{ stdenv, fetchFromGitHub, cmake, pkgconfig, openal, opencv,
  libtoxcore, libsodium, libXScrnSaver, glib, gdk_pixbuf, gtk2, cairo, xorg,
  pango, atk, qrencode, ffmpeg, filter-audio, makeQtWrapper,
  qtbase, qtsvg, qttools, qttranslations, sqlcipher,
  libvpx, libopus }:

stdenv.mkDerivation rec {
  name = "qtox-${version}";
  version = "1.10.0";

  src = fetchFromGitHub {
    owner  = "tux3";
    repo   = "qTox";
    rev    = "v${version}";
    sha256 = "00pbb788147qxpzj3kfp6x6a9w2h8rmz0sdwfzzdjh1qyb43d4q0";
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

  cmakeFlags = [
    "-DGIT_DESCRIBE=${version}"
  ];

  installPhase = ''
    runHook preInstall

    install -Dm755 qtox $out/bin/qtox
    wrapQtProgram $out/bin/qtox

    runHook postInstall
  '';

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Qt Tox client";
    license = licenses.gpl3;
    maintainers = with maintainers; [ viric jgeerds akaWolf peterhoeg ];
    platforms = platforms.all;
  };
}

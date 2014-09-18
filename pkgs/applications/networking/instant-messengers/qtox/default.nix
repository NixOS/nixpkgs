{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, qt5, openal, opencv }:


stdenv.mkDerivation rec {
  name = "qtox-dev-20140918";

  src = fetchFromGitHub {
    owner = "tux3";
    repo = "qTox";
    rev = "f06ec65bca";
    sha256 = "0r7qc444bgsxawyya5nw3xk1c50b90307lcwazs8mn35h4snr97m";
  };

  buildInputs = [ pkgconfig libtoxcore qt5 openal opencv ];

  configurePhase = "qmake";

  installPhase = ''
    ensureDir $out/bin
    cp qtox $out/bin
  '';

  meta = with stdenv.lib; {
    description = "QT Tox client";
    license = licenses.gpl3;
    maintainers = with stdenv.lib.maintainers; [ viric ];
    platforms = stdenv.lib.platforms.all;
  };
}

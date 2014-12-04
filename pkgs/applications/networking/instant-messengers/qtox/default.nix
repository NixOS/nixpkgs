{ stdenv, fetchFromGitHub, pkgconfig, libtoxcore, qt5, openalSoft, opencv
, libsodium }:


stdenv.mkDerivation rec {
  name = "qtox-dev-20141201";

  src = fetchFromGitHub {
    owner = "tux3";
    repo = "qTox";
    rev = "qtox-windows-1417469442.11";
    sha256 = "02nxj0w5qbgc79n8mgyqldk1yadf4p8pysn79f7fvi8fxq4j0j5n";
  };

  buildInputs = [ pkgconfig libtoxcore qt5 openalSoft opencv libsodium ];

  configurePhase = "qmake";

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

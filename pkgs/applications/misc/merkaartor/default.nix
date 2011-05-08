{stdenv, fetchurl, qt4, boost}:

stdenv.mkDerivation rec {
  name = "merkaartor-0.17.2";
  src = fetchurl {
    url = "http://www.merkaartor.org/downloads/source/${name}.tar.bz2";
    sha256 = "0akhp9czzn39132mgj9h38nlh4l9ibzn3vh93bfs685zxyn4yps2";
  };

  configurePhase = ''
    qmake -makefile PREFIX=$out
  '';

  buildInputs = [ qt4 boost ];

  meta = {
    description = "An openstreetmap editor";
    homepage = http://merkaartor.org/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric urkud];
    inherit (qt4.meta) platforms;
  };
}

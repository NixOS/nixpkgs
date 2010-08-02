{stdenv, fetchurl, qt, boost}:

stdenv.mkDerivation {
  name = "merkaartor-0.16.0";
  src = fetchurl {
    url = http://www.merkaartor.org/downloads/source/merkaartor-0.16.0.tar.bz2;
    sha256 = "0l33vgwwkqj65i86qq5j33bbf6q02hs8r1frjnd7icqdaqqv08d7";
  };

  configurePhase = ''
    qmake -makefile PREFIX=$out
  '';

  buildInputs = [ qt boost ];

  meta = {
    description = "An openstreetmap editor";
    homepage = http://merkaartor.org/;
    license = "GPLv2+";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = qt.meta.platforms;
  };
}

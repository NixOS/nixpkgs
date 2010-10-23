{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "arora-${version}";
  version = "0.11.0";

  src = fetchurl {
    url = "http://arora.googlecode.com/files/${name}.tar.gz";
    sha256 = "1ffkranxi93lrg5r7a90pix9j8xqmf0z1mb1m8579v9m34cyypvg";
  };

  buildInputs = [ qt4 ];

  configurePhase = "qmake PREFIX=$out";

  meta = with stdenv.lib; {
    platforms = qt4.meta.platforms;
    maintainers = [ maintainers.phreedom ];
    description = "A cross-platform Qt4 Webkit browser";
    homepage = http://arora.googlecode.com;
  };
}

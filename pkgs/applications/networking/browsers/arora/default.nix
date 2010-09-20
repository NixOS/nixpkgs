{ stdenv, fetchurl, qt4 }:

stdenv.mkDerivation rec {
  name = "arora-${version}";
  version = "0.10.2";

  src = fetchurl {
    url = "http://arora.googlecode.com/files/${name}.tar.gz";
    sha256 = "1np9xiy7vkpz4dar6ka90wxw4nkwapjafyjzqrv7ghnc3nqdnnvv";
  };

  buildInputs = [ qt4 ];

  configurePhase = "qmake PREFIX=$out";

  meta = with stdenv.lib; {
    platforms = qt.meta.platforms;
    maintainers = [ maintainers.phreedom ];
    description = "A cross-platform Qt4 Webkit browser";
    homepage = http://rekonq.sourceforge.net;
  };
}

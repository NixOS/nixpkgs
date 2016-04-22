{ fetchurl, stdenv, db, boost, gmp, mpfr, miniupnpc, qt4, qmake4Hook, unzip }:

stdenv.mkDerivation rec {
  version = "0.8.3-1";
  name = "freicoin-${version}";

  src = fetchurl {
    url = "https://github.com/freicoin/freicoin/archive/v${version}.zip";
    sha256 = "0v3mh8a96nnb86mkyaylyjj7qfdrl7i9gvybh7f8w2hrl9paszfh";
  };

  # I think that openssl and zlib are required, but come through other
  # packages
  buildInputs = [ db boost gmp mpfr miniupnpc qt4 unzip qmake4Hook ];

  installPhase = ''
    mkdir -p $out/bin
    cp freicoin-qt $out/bin
  '';

  meta = {
    description = "Peer-to-peer currency with demurrage fee";
    homepage = "http://freicoi.in/";
    license = stdenv.lib.licenses.mit;
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

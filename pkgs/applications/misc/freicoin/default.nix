{ fetchurl, stdenv, db4, boost, gmp, mpfr, miniupnpc, qt4, unzip }:

stdenv.mkDerivation rec {
  version = "0.0.1-3";
  name = "freicoin-${version}";

  src = fetchurl {
    url = "https://github.com/freicoin/freicoin/archive/v${version}.zip";
    sha256 = "19q4llv67kmvfr0x56rnqcf0d050dayv246q4i51mmkvjijc1qpf";
  };

  # I think that openssl and zlib are required, but come through other
  # packages
  buildInputs = [ db4 boost gmp mpfr miniupnpc qt4 unzip ];

  configurePhase = "qmake";

  installPhase = ''
    mkdir -p $out/bin
    cp freicoin-qt $out/bin
  '';

  meta = {
    description = "Peer-to-peer currency with demurrage fee";
    homepage = "http://freicoi.in/";
    license = "MIT";
    maintainers = with stdenv.lib.maintainers; [viric];
    platforms = with stdenv.lib.platforms; linux;
  };
}

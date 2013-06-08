{ fetchurl, stdenv, db4, boost, gmp, mpfr, miniupnpc, qt4, unzip }:

stdenv.mkDerivation rec {
  version = "0.0.2";
  name = "freicoin-${version}";

  src = fetchurl {
    url = "https://github.com/freicoin/freicoin/archive/v${version}.zip";
    sha256 = "09izmm85rb64d5hd0hz9hkfvv3qag55sb3mdyp8z4103icqwd6d7";
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

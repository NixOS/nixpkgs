{ fetchurl, stdenv, openssl, db4, boost, zlib, miniupnpc, qt4 }:

stdenv.mkDerivation rec {
  version = "0.5.0";
  name = "bitcoin-${version}";

  src = fetchurl {
    url = " https://github.com/bitcoin/bitcoin/tarball/v${version}";
    sha256 = "1i9wnbjf9yrs9rq5jnh9pk1x5j982qh3xpjm05z8dgd3nympgyy8";
  };

  buildInputs = [ openssl db4 boost zlib miniupnpc qt4 ];

  unpackCmd = "tar xvf $curSrc";

  buildPhase = ''
    qmake
    make
    cd src
    make -f makefile.unix
    cd ..
  '';

  installPhase = ''
    ensureDir $out/bin
    cp bitcoin-qt $out/bin
    cp src/bitcoind $out/bin
  '';

  meta = { 
      description = "Bitcoin is a peer-to-peer currency";
      longDescription=''
Bitcoin is a free open source peer-to-peer electronic cash system that is
completely decentralized, without the need for a central server or trusted
parties.  Users hold the crypto keys to their own money and transact directly
with each other, with the help of a P2P network to check for double-spending.
      '';
      homepage = "http://www.bitcoin.org/";
      maintainers = [ stdenv.lib.maintainers.roconnor ];
      license = "MIT";
  };
}

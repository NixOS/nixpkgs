{ fetchurl, stdenv, openssl, db4, boost, zlib, miniupnpc, qt4 }:

stdenv.mkDerivation rec {
  version = "0.6.2";
  name = "bitcoin-${version}";

  src = fetchurl {
    url = "mirror://sourceforge/bitcoin/bitcoin-0.6.2-linux.tar.gz";
    sha256 = "0yhgqz98hmmn6ljk23rd48jsjfvzdii27370vazhbgvjwj8giais";
  };

  buildInputs = [ openssl db4 boost zlib miniupnpc qt4 ];

  configurePhase = ''
    cd src
    qmake
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp bitcoin-qt $out/bin
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

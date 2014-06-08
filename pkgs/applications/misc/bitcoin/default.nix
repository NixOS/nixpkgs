{ fetchurl, stdenv, openssl, db48, boost, zlib, miniupnpc, qt4, utillinux
, pkgconfig, protobuf, qrencode }:

stdenv.mkDerivation rec {
  version = "0.9.1";
  name = "bitcoin-${version}";

  src = fetchurl {
    url = "https://bitcoin.org/bin/${version}/${name}-linux.tar.gz";
    sha256 = "3fabc1c629007b465a278525883663d41a2ba62699f2773536a8bf59ca210425";
  };

  # hexdump from utillinux is required for tests
  buildInputs = [
    openssl db48 boost zlib miniupnpc qt4 utillinux pkgconfig protobuf qrencode
  ];

  unpackPhase = ''
    mkdir tmp-extract && (cd tmp-extract && tar xf $src)
    tar xf tmp-extract/bitcoin*/src/bitcoin*.tar*
    cd bitcoin*
  '';

  configureFlags = [
    "--with-boost=${boost}"
  ];

  preCheck = ''
    # At least one test requires writing in $HOME
    HOME=$TMPDIR
  '';

  doCheck = true;

  enableParallelBuilding = true;

  meta = {
      description = "Bitcoin is a peer-to-peer currency";
      longDescription= ''
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

{ fetchurl, stdenv, openssl, db48, boost, zlib, miniupnpc, qt4, utillinux
, pkgconfig, protobuf, qrencode, gui ? true }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.9.2.1";
  name = "bitcoin${toString (optional (!gui) "d")}-${version}";

  src = fetchurl {
    url = "https://bitcoin.org/bin/${version}/bitcoin-${version}-linux.tar.gz";
    sha256 = "0060f7d38b98113ab912d4c184000291d7f026eaf77ca5830deec15059678f54";
  };

  # hexdump from utillinux is required for tests
  buildInputs = [
    openssl db48 boost zlib miniupnpc utillinux pkgconfig protobuf 
  ] ++ optionals gui [ qt4 qrencode ];

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

  passthru.walletName = "bitcoin";

  meta = {
      description = "Peer-to-peer electronic cash system";
      longDescription= ''
        Bitcoin is a free open source peer-to-peer electronic cash system that is
        completely decentralized, without the need for a central server or trusted
        parties.  Users hold the crypto keys to their own money and transact directly
        with each other, with the help of a P2P network to check for double-spending.
      '';
      homepage = "http://www.bitcoin.org/";
      maintainers = [ maintainers.roconnor ];
      license = licenses.mit;
  };
}

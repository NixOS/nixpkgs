{ fetchurl, stdenv, openssl, db48, boost, zlib, miniupnpc, qt4, utillinux
, pkgconfig, protobuf, qrencode, gui ? true }:

with stdenv.lib;

stdenv.mkDerivation rec {
  version = "0.9.3";
  name = "bitcoin${toString (optional (!gui) "d")}-${version}";

  src = fetchurl {
    url = "https://bitcoin.org/bin/${version}/bitcoin-${version}-linux.tar.gz";
    sha256 = "1kb59w7232qzfh952rz6vvjri2w26n9cq7baml0vifdsdhxph9f4";
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

{ fetchurl, stdenv, openssl, db4, boost, zlib, miniupnpc, qt4, qrencode }:

stdenv.mkDerivation rec {
  version = "1.4";
  name = "dogecoin-${version}";

  src = fetchurl {
    url = "https://github.com/dogecoin/dogecoin/archive/1.4.tar.gz";
    sha256 = "4af983f182976c98f0e32d525083979c9509b28b7d6faa0b90c5bd40b71009cc";
  };

  buildInputs = [ openssl db4 boost zlib miniupnpc qt4 qrencode ];

  configurePhase = "";

  buildPhase = ''
    qmake
    make
    cd src
    make -f makefile.unix USE_UPNP=1 USE_IPV6=1 USE_QRCODE=1
    cd -
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp src/dogecoind $out/bin
    cp dogecoin-qt $out/bin
  '';

  meta = {
      description = "Wow, such coin, much shiba, very rich";
      longDescription= "wow";
      homepage = "http://www.dogecoin.com/";
      maintainers = [ stdenv.lib.maintainers.edwtjo ];
      license = "MIT";
  };
}

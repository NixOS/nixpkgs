{ fetchurl, stdenv, pkgconfig
, openssl, db48, boost, zlib, miniupnpc, qt4, qrencode, glib, protobuf
, utillinux
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "darkcoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "0.10.99.99";

  src = fetchurl {
    url = "https://github.com/darkcoin/darkcoin/archive/v${version}.tar.gz";
    sha256 = "1a05a7l878klg4wqk9ykndkhyknrd7jp75v38k99qgk5fi8wa752";
  };

  buildInputs = [ pkgconfig glib openssl db48 boost zlib miniupnpc ]
                  ++ optionals withGui [ qt4 qrencode ];

  configurePhase = optional withGui "qmake";

  preBuild = optional (!withGui) "cd src; cp makefile.unix Makefile";

  installPhase =
    if withGui
    then "install -D darkcoin-qt $out/bin/darkcoin-qt"
    else "install -D darkcoind $out/bin/darkcoind";

  meta = with stdenv.lib; {
    description = "A decentralized key/value registration and transfer system";
    longDescription = ''
      Darkcoin (DRK) is an open sourced, privacy-centric digital
      currency. It allows you keep your finances private as you make
      transactions, similar to cash.
    '';
    homepage = http://darkcoin.io;
    maintainers = with maintainers; [ AndersonTorres ];
    platforms = with platforms; unix;
  };
}

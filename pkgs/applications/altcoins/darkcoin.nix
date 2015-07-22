{ fetchzip, stdenv, pkgconfig
, openssl, db48, boost, zlib, miniupnpc, qt4, qrencode, glib, protobuf
, utillinux
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "darkcoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "0.10.99.99";

  src = fetchzip {
    url = "https://github.com/darkcoin/darkcoin/archive/v${version}.tar.gz";
    sha256 = "0sigvimqwc1mvaq43a8c2aq7fjla2ncafrals08qfq3jd6in8b4f";
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

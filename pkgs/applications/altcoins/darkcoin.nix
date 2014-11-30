{ fetchurl, stdenv, pkgconfig
, openssl, db48, boost, zlib, miniupnpc, qt4, qrencode, glib, protobuf
, utillinux
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec {

  name = "darkcoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "0.9.13.15";

  src = fetchurl {
    url = "https://github.com/darkcoin/darkcoin/archive/v${version}.tar.gz";
    sha256 = "1kly2y3g4dr1jwwf81smqvc7k662x6rvg4ggmxva1yaifb67bgjb";
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

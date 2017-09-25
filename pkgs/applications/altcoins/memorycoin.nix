{ stdenv, fetchurl, pkgconfig, openssl, db48, boost
, zlib, qt4, qmake4Hook, utillinux, protobuf, qrencode
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "memorycoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "0.8.5";

  src = fetchurl {
    url = "https://github.com/memorycoin/memorycoin/archive/v${version}.tar.gz";
    sha256 = "1iyh6dqrg0mirwci5br5n5qw3ghp2cs23wd8ygr56bh9ml4dr1m8";
  };

  buildInputs = [ pkgconfig openssl db48 boost zlib utillinux protobuf ]
                  ++ optionals withGui [ qt4 qmake4Hook qrencode ];

  qmakeFlags = ["USE_UPNP=-"];
  makeFlags = ["USE_UPNP=-"];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt4" ];

  preBuild = "unset AR;"
             + (toString (optional (!withGui) "cd src; cp makefile.unix Makefile"));

  installPhase =
    if withGui
    then "install -D bitcoin-qt $out/bin/memorycoin-qt"
    else "install -D bitcoind $out/bin/memorycoind";

  meta = {
    description = "Peer-to-peer, CPU-based electronic cash system";
    longDescription= ''
      Memorycoin is a cryptocurrency that aims to empower the
      economically and financially marginalized. It allows individuals
      to participate in the internet economy even when they live in
      countries where credit card companies and PayPal(R) refuse to
      operate. Individuals can store and transfer wealth with just a
      memorized pass phrase.

      Memorycoin is based on the Bitcoin code, but with some key
      differences.
    '';
    homepage = http://www.bitcoin.org/;
    maintainers = with maintainers; [ AndersonTorres ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

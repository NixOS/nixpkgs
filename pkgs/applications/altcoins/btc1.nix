{ stdenv, fetchurl, pkgconfig, autoreconfHook, hexdump, openssl, db48
, boost, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode, libevent
, AppKit
, withGui ? !stdenv.isDarwin
}:

with stdenv.lib;
stdenv.mkDerivation rec{
  name = "bit1" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "1.15.1";

  src = fetchurl {
    url = "https://github.com/btc1/bitcoin/archive/v${version}.tar.gz";
    sha256 = "0v0g2wb4nsnhddxzb63vj2bc1mgyj05vqm5imicjfz8prvgc0si8";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook hexdump ];
  buildInputs = [ openssl db48 boost zlib miniupnpc protobuf libevent ]
    ++ optionals withGui [ qt4 qrencode ]
    ++ optional stdenv.isDarwin AppKit;

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt4" ];

  meta = {
    description = "Peer-to-peer electronic cash system (btc1 client)";
    longDescription= ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.

      btc1 is an implementation of a Bitcoin full node with segwit2x hard fork
      support.
    '';
    homepage = "https://github.com/btc1/bitcoin";
    license = licenses.mit;
    maintainers = with maintainers; [ sorpaas ];
    platforms = platforms.unix;
  };
}

{ stdenv, fetchurl, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode, libevent
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec{
  name = "bit1" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "1.14.5";

  src = fetchurl {
    url = "https://github.com/btc1/bitcoin/archive/v${version}.tar.gz";
    sha256 = "1az6bbblh3adgcs16r9cjz8jacg6sbwfpg8zzfzkbp9h9j85ass5";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib
                  miniupnpc protobuf libevent]
                  ++ optionals stdenv.isLinux [ utillinux ]
                  ++ optionals withGui [ qt4 qrencode ];

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

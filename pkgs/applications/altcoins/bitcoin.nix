{ stdenv, fetchurl, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode, libevent
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec{
  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "0.15.2";

  src = fetchurl {
    url = "https://bitcoin.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz";
    sha256 = "0lbbvzf8v1665kjqqsc7prjqswmhyr56fgyckm2q5fix6ya2vgx1";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib
                  miniupnpc protobuf libevent]
                  ++ optionals stdenv.isLinux [ utillinux ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt4" ];

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription= ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = http://www.bitcoin.org/;
    maintainers = with maintainers; [ roconnor AndersonTorres ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

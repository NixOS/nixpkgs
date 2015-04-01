{ stdenv, fetchurl, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec{

  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "0.10.0";

  src = fetchurl {
    url = "https://bitcoin.org/bin/bitcoin-core-0.10.0/bitcoin-${version}.tar.gz";
    sha256 = "a516cf6d9f58a117607148405334b35d3178df1ba1c59229609d2bcd08d30624";
  };

  buildInputs = [ pkgconfig autoreconfHook openssl db48 boost zlib
                  miniupnpc utillinux protobuf ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.lib}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt4" ];

  meta = {
    description = "Peer-to-peer electronic cash system";
    longDescription= ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.
    '';
    homepage = "http://www.bitcoin.org/";
    maintainers = with maintainers; [ roconnor AndersonTorres ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

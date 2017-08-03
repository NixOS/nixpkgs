{ stdenv, fetchurl, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode, libevent
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec{
  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-" + version;
  version = "0.14.0";

  src = fetchurl {
    urls = [ "https://bitcoin.org/bin/bitcoin-core-${version}/bitcoin-${version}.tar.gz"
             "mirror://sourceforge/bitcoin/Bitcoin/bitcoin-${version}/bitcoin-${version}.tar.gz"
           ];
    sha256 = "07k4i9r033dsvkp5ii5g3hykidm8b19c8c0mz1bi8k0dda3d8hyp";
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

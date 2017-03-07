{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode, libevent
, withGui }:

with stdenv.lib;

stdenv.mkDerivation rec {

  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-classic-" + version;
  version = "1.2.1";

  src = fetchFromGitHub {
    owner = "bitcoinclassic";
    repo = "bitcoinclassic";
    rev = "v${version}";
    sha256 = "0ykblw6mb8bh2pa50iqgc5f07mmsz4m3yajsphqgiv5n2fwmkzng";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib
                  miniupnpc utillinux protobuf libevent ]
                  ++ optionals withGui [ qt4 qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt4" ];

  meta = {
    description = "Peer-to-peer electronic cash system (Classic client)";
    longDescription= ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.

      We call our code repository Bitcoin Classic. It starts as a one-feature patch
      to bitcoin-core that increases the blocksize limit to 2 MB. We will have
      ports for master and 0.11.2, so that miners and businesses can upgrade to 2 MB
      blocks from any recent bitcoin software version they run. In the future we will
      continue to release updates that are in line with Satoshi’s whitepaper &
      vision, and are agreed upon by the community.
    '';
    homepage = https://bitcoinclassic.com/;
    maintainers = with maintainers; [ jefdaj ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

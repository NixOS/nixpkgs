{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt4, utillinux, protobuf, qrencode, libevent
, withGui
, Foundation, ApplicationServices, AppKit }:

with stdenv.lib;

stdenv.mkDerivation rec {

  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-unlimited-" + version;
  version = "1.0.3.0";

  src = fetchFromGitHub {
    owner = "bitcoinunlimited";
    repo = "bitcoinunlimited";
    rev = "v${version}";
    sha256 = "0l02a7h502msrp4c02wgm7f3159ap8l61k4890vas99gq7ywxkcx";
  };

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib
                  miniupnpc utillinux protobuf libevent ]
                  ++ optionals withGui [ qt4 qrencode ]
                  ++ optionals stdenv.isDarwin [ Foundation ApplicationServices AppKit ];

  patches = [
    ./bitcoin-unlimited-const-comparators.patch
  ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt4" ];
  enableParallelBuilding = true;

  meta = {
    description = "Peer-to-peer electronic cash system (Unlimited client)";
    longDescription= ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.

      The Bitcoin Unlimited (BU) project seeks to provide a voice to all
      stakeholders in the Bitcoin ecosystem.

      Every node operator or miner can currently choose their own blocksize limit
      by modifying their client. Bitcoin Unlimited makes the process easier by
      providing a configurable option for the accepted and generated blocksize via
      a GUI menu. Bitcoin Unlimited further provides a user-configurable failsafe
      setting allowing you to accept a block larger than your maximum accepted
      blocksize if it reaches a certain number of blocks deep in the chain.

      The Bitcoin Unlimited client is not a competitive block scaling proposal
      like BIP-101, BIP-102, etc. Instead it tracks consensus. This means that it
      tracks the blockchain that the hash power majority follows, irrespective of
      blocksize, and signals its ability to accept larger blocks via protocol and
      block versioning fields.

      If you support an increase in the blocksize limit by any means - or just
      support Bitcoin conflict resolution as originally envisioned by its founder -
      consider running a Bitcoin Unlimited client.
    '';
    homepage = https://www.bitcoinunlimited.info/;
    maintainers = with maintainers; [ DmitryTsygankov ];
    license = licenses.mit;
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
  };
}

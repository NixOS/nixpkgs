{ lib, stdenv, fetchFromGitLab, pkg-config, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, util-linux, protobuf, qrencode, libevent, python3
, withGui, wrapQtAppsHook ? null, qtbase ? null, qttools ? null
, Foundation, ApplicationServices, AppKit }:

with lib;

stdenv.mkDerivation rec {
  pname = "bitcoin" + optionalString (!withGui) "d" + "-unlimited";
  version = "1.10.0.0";

  src = fetchFromGitLab {
    owner = "bitcoinunlimited";
    repo = "BCHUnlimited";
    rev = "BCHunlimited${version}";
    sha256 = "sha256-d+giTXq/6HpysRAPT7yOl/B1x4zie9irs4O7cJsBqHg=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook python3 ]
    ++ optionals withGui [ wrapQtAppsHook qttools ];
  buildInputs = [ openssl db48 boost zlib
                  miniupnpc util-linux protobuf libevent ]
                  ++ optionals withGui [ qtbase qttools qrencode ]
                  ++ optionals stdenv.isDarwin [ Foundation ApplicationServices AppKit ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt5"
                                            "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
                                          ];
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
    homepage = "https://www.bitcoinunlimited.info/";
    maintainers = with maintainers; [ DmitryTsygankov ];
    license = licenses.mit;
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
  };
}

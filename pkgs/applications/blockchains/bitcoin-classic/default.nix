{ lib
, stdenv
, fetchFromGitHub
, pkg-config
, autoreconfHook
, openssl
, db48
, boost
, zlib
, miniupnpc
, qtbase ? null
, qttools ? null
, util-linux
, protobuf
, qrencode
, libevent
, withGui
}:

stdenv.mkDerivation rec {
  pname = "bitcoin" + lib.optionalString (!withGui) "d" + "-classic";
  version = "1.3.8uahf";

  src = fetchFromGitHub {
    owner = "bitcoinclassic";
    repo = "bitcoinclassic";
    rev = "v${version}";
    sha256 = "sha256-fVmFD1B4kKoejd2cmPPF5TJJQTAA6AVsGlVY8IIUNK4=";
  };

  nativeBuildInputs = [ pkg-config autoreconfHook ];
  buildInputs = [
    openssl
    db48
    boost
    zlib
    miniupnpc
    util-linux
    protobuf
    libevent
  ] ++ lib.optionals withGui [ qtbase qttools qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
    ++ lib.optionals withGui [
    "--with-gui=qt5"
    "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  CXXFLAGS = [ "-std=c++14" ];

  enableParallelBuilding = true;

  dontWrapQtApps = true;

  meta = with lib; {
    description = "Peer-to-peer electronic cash system (Classic client)";
    longDescription = ''
      Bitcoin is a free open source peer-to-peer electronic cash system that is
      completely decentralized, without the need for a central server or trusted
      parties. Users hold the crypto keys to their own money and transact directly
      with each other, with the help of a P2P network to check for double-spending.

      Bitcoin Classic stands for the original Bitcoin as Satoshi described it,
      "A Peer-to-Peer Electronic Cash System". We are writing the software that
      miners and users say they want. We will make sure it solves their needs, help
      them deploy it, and gracefully upgrade the bitcoin network's capacity
      together. The data shows that Bitcoin can grow, on-chain, to welcome many
      more users onto our coin in a safe and distributed manner. In the future we
      will continue to release updates that are in line with Satoshi’s whitepaper &
      vision, and are agreed upon by the community.
    '';
    homepage = "https://bitcoinclassic.com/";
    maintainers = with maintainers; [ jefdaj ];
    license = licenses.mit;
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
  };
}

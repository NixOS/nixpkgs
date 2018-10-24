{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qtbase ? null, qttools ? null, utillinux, protobuf, qrencode, libevent
, withGui }:

with stdenv.lib;

stdenv.mkDerivation rec {

  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-classic-" + version;
  version = "1.3.8";

  src = fetchFromGitHub {
    owner = "bitcoinclassic";
    repo = "bitcoinclassic";
    rev = "v${version}";
    sha256 = "06ij9v7zbdnhxq9429nnxiw655cp8idldj18l7fmj94gqx07n5vh";
  };

  patches = [ ./fix-bitcoin-qt-build.patch ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib
                  miniupnpc utillinux protobuf libevent ]
                  ++ optionals withGui [ qtbase qttools qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt5" ];

  meta = {
    description = "Peer-to-peer electronic cash system (Classic client)";
    longDescription= ''
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
    homepage = https://bitcoinclassic.com/;
    maintainers = with maintainers; [ jefdaj ];
    license = licenses.mit;
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
  };
}

{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qt5, utillinux, protobuf, qrencode, libevent
, withGui }:

with stdenv.lib;

stdenv.mkDerivation rec {

  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-abc-" + version;
  version = "0.15.0";

  src = fetchFromGitHub {
    owner = "bitcoin-ABC";
    repo = "bitcoin-abc";
    rev = "v${version}";
    sha256 = "1fygn6cc99iasg5g5jyps5ps873hfnn4ln4hsmcwlwiqd591qxyv";
  };

  patches = [ ./fix-bitcoin-qt-build.patch ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib
                  miniupnpc utillinux protobuf libevent ]
                  ++ optionals withGui [ qt5.qtbase qt5.qttools qrencode ];

  configureFlags = [ "--with-boost-libdir=${boost.out}/lib" ]
                     ++ optionals withGui [ "--with-gui=qt5" ];

  meta = {
    description = "Peer-to-peer electronic cash system (Cash client)";
    longDescription= ''
      Bitcoin ABC is the name of open source software which enables the use of Bitcoin.
      It is designed to facilite a hard fork to increase Bitcoin's block size limit.
      "ABC" stands for "Adjustable Blocksize Cap".

      Bitcoin ABC is a fork of the Bitcoin Core software project.
    '';
    homepage = https://bitcoinabc.org/;
    maintainers = with maintainers; [ lassulus ];
    license = licenses.mit;
    platforms = platforms.unix;
  };
}

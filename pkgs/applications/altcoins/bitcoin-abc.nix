{ stdenv, fetchFromGitHub, pkgconfig, autoreconfHook, openssl, db48, boost
, zlib, miniupnpc, qtbase ? null , qttools ? null, utillinux, protobuf, qrencode, libevent
, withGui }:

with stdenv.lib;

stdenv.mkDerivation rec {

  name = "bitcoin" + (toString (optional (!withGui) "d")) + "-abc-" + version;
  version = "0.17.1";

  src = fetchFromGitHub {
    owner = "bitcoin-ABC";
    repo = "bitcoin-abc";
    rev = "v${version}";
    sha256 = "1kq9n3s9vhkmfaizsyi2cb91ibi06gb6wx0hkcb9hg3nrrvcka3y";
  };

  patches = [ ./fix-bitcoin-qt-build.patch ];

  nativeBuildInputs = [ pkgconfig autoreconfHook ];
  buildInputs = [ openssl db48 boost zlib
                  miniupnpc utillinux protobuf libevent ]
                  ++ optionals withGui [ qtbase qttools qrencode ];

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
    broken = stdenv.isDarwin;
    platforms = platforms.unix;
  };
}

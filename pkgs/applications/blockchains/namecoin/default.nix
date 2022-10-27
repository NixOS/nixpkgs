{ lib, stdenv, fetchFromGitHub, openssl, boost, libevent, autoreconfHook, db4, miniupnpc, eject, pkg-config, qt4, protobuf, qrencode, hexdump
, withGui }:

stdenv.mkDerivation rec {
  pname = "namecoin" + lib.optionalString (!withGui) "d";
  version = "23.0";

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "namecoin-core";
    rev = "nc${version}";
    sha256 = "sha256-MfqJ7EcJvlQ01Mr1RQpXVNUlGIwNqFTxrVwGa+Hus+A=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    hexdump
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    miniupnpc
    eject
  ] ++ lib.optionals withGui [
    qt4
    protobuf
    qrencode
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = with lib; {
    description = "Decentralized open source information registration and transfer system based on the Bitcoin cryptocurrency";
    homepage = "https://namecoin.org";
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.linux;
  };
}

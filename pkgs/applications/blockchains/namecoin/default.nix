{ lib, stdenv, fetchFromGitHub, openssl, boost, libevent, autoreconfHook, db4, miniupnpc, eject, pkg-config, qt4, protobuf, qrencode, hexdump
, withGui }:

with lib;
stdenv.mkDerivation rec {
  pname = "namecoin" + optionalString (!withGui) "d";
  version = "nc23.0";

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "namecoin-core";
    rev = version;
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
  ] ++ optionals withGui [
    qt4
    protobuf
    qrencode
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = {
    description = "Decentralized open source information registration and transfer system based on the Bitcoin cryptocurrency";
    homepage = "https://namecoin.org";
    license = licenses.mit;
    maintainers = with maintainers; [ infinisil ];
    platforms = platforms.linux;
  };
}

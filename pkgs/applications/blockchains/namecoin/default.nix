{ lib, stdenv, fetchFromGitHub, openssl, boost, libevent, autoreconfHook, db4, miniupnpc, eject, pkg-config, protobuf, qrencode, hexdump
, qtbase, qttools, wrapQtAppsHook
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
    wrapQtAppsHook
    qtbase
    qttools
    protobuf
    qrencode
  ];

  LRELEASE = "${qttools}/bin/lrelease";

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

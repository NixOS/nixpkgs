{ stdenv, fetchFromGitHub, openssl, boost, libevent, autoreconfHook, db4, miniupnpc, eject, pkgconfig, qt4, protobuf, libqrencode, hexdump
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "nc0.16.2";
  name = "namecoin" + toString (optional (!withGui) "d") + "-" + version;

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "namecoin-core";
    rev = version;
    sha256 = "0msjpzx8zb9pk9h3p2z5wbv679nq5aywg1q4bm5x04x3nszwfvyf";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
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
    libqrencode
  ];

  enableParallelBuilding = true;

  configureFlags = [
    "--with-boost-libdir=${boost.out}/lib"
  ];

  meta = {
    description = "Decentralized open source information registration and transfer system based on the Bitcoin cryptocurrency";
    homepage = https://namecoin.org;
    license = licenses.mit;
    maintainers = with maintainers; [ doublec AndersonTorres infinisil ];
    platforms = platforms.linux;
  };
}

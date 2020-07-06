{ stdenv, fetchFromGitHub, openssl, boost, libevent, autoreconfHook, db4, miniupnpc, eject, pkgconfig, qt4, protobuf, qrencode, hexdump
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "nc0.20.0";
  name = "namecoin" + toString (optional (!withGui) "d") + "-" + version;

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "namecoin-core";
    rev = version;
    sha256 = "115nlsq5g169mj4qjmkhxx1bnx740871zqyng9zbm2y4i0xf71c4";
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
    maintainers = with maintainers; [ doublec AndersonTorres infinisil ];
    platforms = platforms.linux;
  };
}

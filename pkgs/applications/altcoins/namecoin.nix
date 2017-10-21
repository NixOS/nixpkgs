{ stdenv, lib, fetchFromGitHub, openssl, boost, libevent, autoreconfHook, db4, miniupnpc, eject, pkgconfig, qt4, protobuf, libqrencode
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "nc0.13.0rc1";
  name = "namecoin" + toString (optional (!withGui) "d") + "-" + version;

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "namecoin-core";
    rev = version;
    sha256 = "17zz0rm3js285w2assxp8blfx830rs0ambcsaqqfli9mnaik3m39";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
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

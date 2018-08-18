{ stdenv, fetchFromGitHub, openssl, boost, libevent, autoreconfHook, db4, miniupnpc, eject, pkgconfig, qt4, protobuf, libqrencode, hexdump
, withGui }:

with stdenv.lib;
stdenv.mkDerivation rec {
  version = "nc0.15.99-name-tab-beta2";
  name = "namecoin" + toString (optional (!withGui) "d") + "-" + version;

  src = fetchFromGitHub {
    owner = "namecoin";
    repo = "namecoin-core";
    rev = version;
    sha256 = "1r0v0yvlazmidxp6xhapbdawqb8fhzrdp11d4an5vgxa208s6wdf";
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

{ lib, stdenv
, fetchFromGitHub
, openssl
, boost
, libevent
, autoreconfHook
, db4
, pkg-config
, protobuf
, hexdump
, zeromq
, withGui
, qtbase ? null
, qttools ? null
, wrapQtAppsHook ? null
}:

with lib;

stdenv.mkDerivation rec {
  pname = "vertcoin";
  version = "0.15.0.1";

  name = pname + toString (optional (!withGui) "d") + "-" + version;

  src = fetchFromGitHub {
    owner = pname + "-project";
    repo = pname + "-core";
    rev = version;
    sha256 = "09q7qicw52gv225hq6wlpsf4zr4hjc8miyim5cygi5nxxrlw7kd3";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    hexdump
  ] ++ optionals withGui [
    wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    zeromq
  ] ++ optionals withGui [
    qtbase
    qttools
    protobuf
  ];

  enableParallelBuilding = true;

  configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
  ] ++ optionals withGui [
      "--with-gui=qt5"
      "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  meta = {
    description = "A digital currency with mining decentralisation and ASIC resistance as a key focus";
    homepage = "https://vertcoin.org/";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}

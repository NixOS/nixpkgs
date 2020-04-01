{ stdenv
, fetchFromGitHub
, openssl
, boost
, libevent
, autoreconfHook
, db4
, pkgconfig
, protobuf
, hexdump
, zeromq
, withGui
, qtbase ? null
, qttools ? null
, wrapQtAppsHook ? null
}:

with stdenv.lib;

stdenv.mkDerivation rec {
  pname = "vertcoin";
  version = "0.14.0";

  name = pname + toString (optional (!withGui) "d") + "-" + version;

  src = fetchFromGitHub {
    owner = pname + "-project";
    repo = pname + "-core";
    rev = version;
    sha256 = "00vnmrhn5mad58dyiz8rxgsrn0663ii6fdbcqm20mv1l313k4882";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkgconfig
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

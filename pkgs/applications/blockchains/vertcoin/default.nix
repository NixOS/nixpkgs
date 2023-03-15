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
, gmp
, withGui
, qtbase ? null
, qttools ? null
, wrapQtAppsHook ? null
}:

stdenv.mkDerivation rec {
  pname = "vertcoin";
  version = "0.18.0";

  name = pname + toString (lib.optional (!withGui) "d") + "-" + version;

  src = fetchFromGitHub {
    owner = pname + "-project";
    repo = pname + "-core";
    rev = "2bd6dba7a822400581d5a6014afd671fb7e61f36";
    sha256 = "ua9xXA+UQHGVpCZL0srX58DDUgpfNa+AAIKsxZbhvMk=";
  };

  nativeBuildInputs = [
    autoreconfHook
    pkg-config
    hexdump
  ] ++ lib.optionals withGui [
    wrapQtAppsHook
  ];

  buildInputs = [
    openssl
    boost
    libevent
    db4
    zeromq
    gmp
  ] ++ lib.optionals withGui [
    qtbase
    qttools
    protobuf
  ];

  enableParallelBuilding = true;

  configureFlags = [
      "--with-boost-libdir=${boost.out}/lib"
  ] ++ lib.optionals withGui [
      "--with-gui=qt5"
      "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
  ];

  meta = with lib; {
    description = "A digital currency with mining decentralisation and ASIC resistance as a key focus";
    homepage = "https://vertcoin.org/";
    license = licenses.mit;
    maintainers = [ maintainers.mmahut ];
    platforms = platforms.linux;
  };
}

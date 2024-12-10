{
  fetchFromGitHub,
  stdenv,
  makeDesktopItem,
  lib,
  openssl,
  boost,
  curl,
  libevent,
  libzip,
  qrencode,
  qtbase,
  qttools,
  wrapQtAppsHook,
  autoreconfHook,
  pkg-config,
  libtool,
  miniupnpc,
  hexdump,
}:

stdenv.mkDerivation rec {
  pname = "gridcoin-research";
  version = "5.4.8.0";

  src = fetchFromGitHub {
    owner = "gridcoin-community";
    repo = "Gridcoin-Research";
    rev = "${version}";
    sha256 = "sha256-HZirzXkqM2aep+wq8k2UCFWHPtN0sBZXjamgt7RYPBo=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapQtAppsHook
    autoreconfHook
    libtool
    hexdump
  ];

  buildInputs = [
    qttools
    qtbase
    qrencode
    libevent
    libzip
    openssl
    boost
    miniupnpc
    curl
  ];

  configureFlags = [
    "--with-gui=qt5"
    "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
    "--with-qrencode"
    "--with-boost-libdir=${boost.out}/lib"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    description = "A POS-based cryptocurrency that rewards users for participating on the BOINC network";
    longDescription = ''
      A POS-based cryptocurrency that rewards users for participating on the BOINC network,
      using peer-to-peer technology to operate with no central authority - managing transactions,
      issuing money and contributing to scientific research are carried out collectively by the network
    '';
    homepage = "https://gridcoin.us/";
    license = licenses.mit;
    maintainers = with maintainers; [ gigglesquid ];
    platforms = platforms.linux;
  };
}

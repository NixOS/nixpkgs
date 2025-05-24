{
  fetchFromGitHub,
  stdenv,
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

  withGui ? true,
  withQrencode ? withGui,
  withUpnp ? false,
}:

stdenv.mkDerivation rec {
  pname = "gridcoin-research";
  version = "5.4.9.0";

  src = fetchFromGitHub {
    owner = "gridcoin-community";
    repo = "Gridcoin-Research";
    rev = "${version}";
    hash = "sha256-nupZB4nNbitpf5EBCNy0e+ovjayAszup/r7qxbxA5jI=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    libtool
    hexdump
  ] ++ lib.optionals withGui [ wrapQtAppsHook ];

  buildInputs =
    [
      libevent
      libzip
      openssl
      boost
      curl
    ]
    ++ lib.optionals withGui [
      qtbase
      qttools
    ]
    ++ lib.optionals withQrencode [
      qrencode
    ]
    ++ lib.optionals withUpnp [
      miniupnpc
    ];

  configureFlags =
    [
      "--with-boost-libdir=${boost.out}/lib"
    ]
    ++ lib.optionals withGui [
      "--with-gui=qt5"
      "--with-qt-bindir=${qtbase.dev}/bin:${qttools.dev}/bin"
    ]
    ++ lib.optionals withQrencode [
      "--with-qrencode"
    ]
    ++ lib.optionals withUpnp [
      "--with-miniupnpc"
      "--enable-upnp-default"
    ];

  enableParallelBuilding = true;

  doCheck = true;

  meta = with lib; {
    description = "POS-based cryptocurrency that rewards users for participating on the BOINC network";
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

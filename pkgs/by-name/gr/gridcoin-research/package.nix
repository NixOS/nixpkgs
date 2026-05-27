{
  stdenv,
  lib,
  fetchFromGitHub,
  qt6,

  # nativeBuildInputs
  cmake,
  pkg-config,

  # buildInputs
  boost,
  curl,
  libevent,
  libzip,
  miniupnpc,
  openssl,
  qrencode,

  # options
  withGui ? true,
  withDbus ? withGui,
  withQrencode ? withGui,
  withUpnp ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = if withGui then "gridcoin-research" else "gridcoin-researchd";
  version = "5.5.0.0";

  src = fetchFromGitHub {
    owner = "gridcoin-community";
    repo = "Gridcoin-Research";
    tag = "${finalAttrs.version}";
    hash = "sha256-PN0yDVHlty+4CcRfMWe4LG6wHXaTOyLo7lxtrVCSLHA=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ lib.optionals withGui [ qt6.wrapQtAppsHook ];

  buildInputs = [
    boost
    curl
    libevent
    libzip
    openssl
  ]
  ++ lib.optionals withGui [
    qt6.qt5compat
    qt6.qtbase
    qt6.qtcharts
    qt6.qttools
  ]
  ++ lib.optionals withQrencode [
    qrencode
  ]
  ++ lib.optionals withUpnp [
    miniupnpc
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_PIE" true)
    (lib.cmakeBool "ENABLE_GUI" withGui)
    (lib.cmakeBool "USE_QT6" withGui)
    (lib.cmakeBool "USE_DBUS" withDbus)
    (lib.cmakeBool "ENABLE_QRENCODE" withQrencode)
    (lib.cmakeBool "ENABLE_UPNP" withUpnp)
    (lib.cmakeBool "DEFAULT_UPNP" withUpnp)
  ];

  meta = {
    description = "POS-based cryptocurrency that rewards users for participating on the BOINC network";
    longDescription = ''
      A POS-based cryptocurrency that rewards users for participating on the BOINC network,
      using peer-to-peer technology to operate with no central authority - managing transactions,
      issuing money and contributing to scientific research are carried out collectively by the network
    '';
    homepage = "https://gridcoin.us/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ gigglesquid ];
    platforms = lib.platforms.linux;
    changelog = "https://github.com/gridcoin-community/Gridcoin-Research/releases/tag/${finalAttrs.src.tag}";
    mainProgram = if withGui then "gridcoinresearch" else "gridcoinresearchd";
  };
})

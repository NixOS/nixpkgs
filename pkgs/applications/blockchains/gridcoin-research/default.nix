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
  fetchpatch2,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gridcoin-research";
  version = "5.4.9.0";

  src = fetchFromGitHub {
    owner = "gridcoin-community";
    repo = "Gridcoin-Research";
    rev = "${finalAttrs.version}";
    hash = "sha256-nupZB4nNbitpf5EBCNy0e+ovjayAszup/r7qxbxA5jI=";
  };

  patches = [
    (fetchpatch2 {
      url = "https://github.com/gridcoin-community/Gridcoin-Research/commit/bab91e95ca8c83f06dcc505e6b3f8b44dc6d50d4.patch";
      sha256 = "sha256-GzurVlR7Tk3pmQfgO9WtHXjX6xHqNzdYqOdbJND7MpA=";
    })
  ];

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
  };
})

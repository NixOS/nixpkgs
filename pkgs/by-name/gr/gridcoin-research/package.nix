{
  fetchFromGitHub,
  stdenv,
  lib,
  openssl,
  boost179,
  curl,
  libevent,
  libzip,
  qrencode,
  libsForQt5,
  autoreconfHook,
  pkg-config,
  libtool,
  miniupnpc,
  hexdump,
  fetchpatch2,
}:

let
  boost = boost179;
in

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
    libsForQt5.wrapQtAppsHook
    autoreconfHook
    libtool
    hexdump
  ];

  buildInputs = [
    libsForQt5.qttools
    libsForQt5.qtbase
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
    "--with-qt-bindir=${libsForQt5.qtbase.dev}/bin:${libsForQt5.qttools.dev}/bin"
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

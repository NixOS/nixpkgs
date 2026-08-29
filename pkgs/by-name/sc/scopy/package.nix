{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libsForQt5,
  extra-cmake-modules,
  boost,
  fftw,
  fftwFloat,
  glib,
  libiio,
  libad9361,
  libm2k,
  libserialport,
  libsigrokdecode,
  libusb1,
  libxml2,
  log4cpp,
  matio,
  spdlog,
  gmp,
  volk,
  gnuradio-scopy,
  gr-scopy,
  gr-m2k,
  qwt-multiaxes,
  genalyzer,
  libtinyiiod,
  python3,
  nix-update-script,
}:

stdenv.mkDerivation rec {
  pname = "scopy";
  version = "2.1.0";

  src = fetchFromGitHub {
    owner = "analogdevicesinc";
    repo = "scopy";
    tag = "v${version}";
    hash = "sha256-Cpz9W17wtVz8YPpMB6soL5ljCgYEDZyrXqtcMtlei30=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    libsForQt5.wrapQtAppsHook
    libsForQt5.qttools
    extra-cmake-modules
    python3
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtsvg
    libsForQt5.qtdeclarative
    libsForQt5.qt3d
    boost
    fftw
    fftwFloat
    glib
    libiio
    libad9361
    libm2k
    libserialport
    libsigrokdecode
    libusb1
    libxml2
    log4cpp
    matio
    spdlog
    gmp
    volk
    gnuradio-scopy
    gr-scopy
    gr-m2k
    qwt-multiaxes
    genalyzer
    libtinyiiod
    libsForQt5.karchive
  ];

  cmakeFlags = [
    "-DENABLE_ALL_PACKAGES=ON"
    "-DENABLE_TESTING=OFF"
  ];

  qtWrapperArgs = [
    "--set SIGROKDECODE_DIR ${libsigrokdecode}/share/libsigrokdecode/decoders"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Software oscilloscope and signal analysis toolset for Analog Devices hardware";
    homepage = "https://github.com/analogdevicesinc/scopy";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ imadnyc ];
    platforms = lib.platforms.linux;
    mainProgram = "scopy";
  };
}

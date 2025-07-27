{
  lib,
  stdenv,
  airspy,
  airspyhf,
  apple-sdk_12,
  aptdec,
  boost,
  cm256cc,
  cmake,
  codec2,
  dab_lib,
  dsdcc,
  faad2,
  fetchFromGitHub,
  fftwFloat,
  flac,
  glew,
  hackrf,
  hidapi,
  ffmpeg,
  libiio,
  libopus,
  libpulseaudio,
  libusb1,
  limesuite,
  libbladeRF,
  mbelib,
  ninja,
  opencv4,
  pkg-config,
  qt6,
  qt6Packages,
  rtl-sdr,
  serialdv,
  sdrplay,
  sgp4,
  soapysdr-with-plugins,
  uhd,
  zlib,
  withSDRplay ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdrangel";
  version = "7.22.8";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Uj6BzMUhhi/0Jz8jKe/MCiXinoKcyXy4DqC/USdkcpA=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    airspy
    airspyhf
    aptdec
    boost
    cm256cc
    codec2
    dab_lib
    dsdcc
    faad2
    ffmpeg
    fftwFloat
    flac
    glew
    hackrf
    hidapi
    libbladeRF
    libiio
    libopus
    libpulseaudio
    libusb1
    limesuite
    mbelib
    opencv4
    qt6Packages.qt5compat
    qt6Packages.qtcharts
    qt6Packages.qtdeclarative
    qt6Packages.qtlocation
    qt6Packages.qtmultimedia
    qt6Packages.qtscxml
    qt6Packages.qtserialport
    qt6Packages.qtspeech
    qt6Packages.qttools
    qt6Packages.qtwebsockets
    qt6Packages.qtwebengine
    rtl-sdr
    serialdv
    sgp4
    soapysdr-with-plugins
    uhd
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ qt6Packages.qtwayland ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ apple-sdk_12 ]
  ++ lib.optionals withSDRplay [ sdrplay ];

  cmakeFlags = [
    "-DAPT_DIR=${aptdec}"
    "-DDAB_DIR=${dab_lib}"
    "-DSGP4_DIR=${sgp4}"
    "-DSOAPYSDR_DIR=${soapysdr-with-plugins}"
    "-Wno-dev"
    "-DENABLE_QT6=ON"
  ];

  meta = {
    description = "Software defined radio (SDR) software";
    homepage = "https://github.com/f4exb/sdrangel";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      SDRangel is an Open Source Qt6 / OpenGL 3.0+ SDR and signal analyzer frontend to various hardware.
    '';
    maintainers = with lib.maintainers; [
      alkeryn
      Tungsten842
    ];
    platforms = lib.platforms.unix;
  };
})

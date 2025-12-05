{
  lib,
  stdenv,
  airspy,
  airspyhf,
  aptdec,
  boost,
  cm256cc,
  cmake,
  codec2,
  dab_lib,
  dsdcc,
  faad2,
  fetchFromGitHub,
  fetchpatch,
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
  version = "7.22.9";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VYSM9ldzx/8tWKQb++qGROSXdeEXIDhGqnnHUmkW4+k=";
  };

  patches = [
    # Fix build with Qt 6.10, remove when the commit reaches a release
    (fetchpatch {
      url = "https://github.com/f4exb/sdrangel/commit/fd6a8d51f8c39fd31b4e864f528bf1921ebd4260.patch";
      hash = "sha256-S8LQbCTEgyEt1wByDsDMqqyQjK5HALtvUIODgQ1skSA=";
    })
  ];

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
      aciceri
      alkeryn
      Tungsten842
    ];
    platforms = lib.platforms.unix;
  };
})

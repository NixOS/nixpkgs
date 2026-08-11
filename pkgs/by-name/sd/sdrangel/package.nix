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
  fftwFloat,
  flac,
  ggmorse,
  glew,
  hackrf,
  hidapi,
  ffmpeg,
  inmarsatc,
  libiio,
  libogg,
  libopus,
  libpulseaudio,
  libunwind,
  libusb1,
  limesuite,
  libbladeRF,
  mbelib,
  ninja,
  opencv4,
  pkg-config,
  qt6,
  qt6Packages,
  rnnoise,
  rtl-sdr,
  serialdv,
  sdrplay,
  sgp4,
  soapysdr-with-plugins,
  uhd,
  zlib,
  withSDRplay ? false,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdrangel";
  version = "7.27.1";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rdPXqA0ySnqh/rlMlfcDLyAd6egbggWHrRQRnXeQPFM=";
  };

  __structuredAttrs = true;
  strictDeps = true;

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
    ggmorse
    glew
    hackrf
    hidapi
    libbladeRF
    libiio
    libogg
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
    rnnoise
    rtl-sdr
    serialdv
    sgp4
    soapysdr-with-plugins
    uhd
    zlib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    inmarsatc
    libunwind
    qt6Packages.qtwayland
    qt6Packages.qtwebengine
  ]
  ++ lib.optionals withSDRplay [ sdrplay ];

  cmakeFlags = [
    (lib.cmakeFeature "APT_DIR" aptdec.outPath)
    (lib.cmakeFeature "DAB_DIR" dab_lib.outPath)
    (lib.cmakeFeature "SGP4_DIR" sgp4.outPath)
    (lib.cmakeFeature "SOAPYSDR_DIR" soapysdr-with-plugins.outPath)
    (lib.cmakeBool "ENABLE_QT6" true)
    "-Wno-dev"
  ];

  passthru.updateScript = nix-update-script { };

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

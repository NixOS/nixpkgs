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
  qt5compat,
  qtcharts,
  qtdeclarative,
  qtlocation,
  qtmultimedia,
  qtscxml,
  qtserialport,
  qtspeech,
  qttools,
  qtwayland,
  qtwebsockets,
  qtwebengine,
  rtl-sdr,
  serialdv,
  sdrplay,
  sgp4,
  soapysdr-with-plugins,
  uhd,
  wrapQtAppsHook,
  zlib,
  withSDRplay ? false,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdrangel";
  version = "7.22.5";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1jZcKx3kvWcaU9Y6StMATsZ05e7qZqA1H3i/ZvWDoKg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapQtAppsHook
  ];

  buildInputs =
    [
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
      qt5compat
      qtcharts
      qtdeclarative
      qtlocation
      qtmultimedia
      qtscxml
      qtserialport
      qtspeech
      qttools
      qtwebsockets
      qtwebengine
      rtl-sdr
      serialdv
      sgp4
      soapysdr-with-plugins
      uhd
      zlib
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [ qtwayland ] ++ lib.optionals withSDRplay [ sdrplay ];

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

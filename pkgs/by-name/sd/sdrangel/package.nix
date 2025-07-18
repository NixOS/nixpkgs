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
  version = "7.22.6";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ymDKHGJNoCOMa1zzFvjTzFa34wP1+iKSfJZZi7Sk/GM=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
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

  patches = [
    # https://github.com/f4exb/sdrangel/pull/2439
    (fetchpatch {
      url = "https://github.com/f4exb/sdrangel/commit/60869b74f96b26e8a173f3f215c2badeaef9a136.patch";
      hash = "sha256-Lq9pyissNmLYavLCISga0EWbRwisGnKiz6UYhzxJatc=";
    })
  ];

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

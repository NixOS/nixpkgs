{ lib
, stdenv
, airspy
, airspyhf
, aptdec
, boost
, cm256cc
, cmake
, codec2
, dab_lib
, dsdcc
, faad2
, fetchFromGitHub
, fftwFloat
, glew
, hackrf
, hidapi
, ffmpeg
, libiio
, libopus
, libpulseaudio
, libusb1
, limesuite
, libbladeRF
, mbelib
, ninja
, opencv4
, pkg-config
, qtcharts
, qtdeclarative
, qtgamepad
, qtgraphicaleffects
, qtlocation
, qtmultimedia
, qtquickcontrols
, qtquickcontrols2
, qtserialport
, qtspeech
, qttools
, qtwebsockets
, qtwebengine
, rtl-sdr
, serialdv
, sdrplay
, sgp4
, soapysdr-with-plugins
, uhd
, wrapQtAppsHook
, zlib
, withSDRplay ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdrangel";
  version = "7.22.0";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
    rev = "v${finalAttrs.version}";
    hash = "sha256-cF6vKwAWz32/XYUWvq/4Wu73TFQ2jaGIFxWmeXmlPCE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapQtAppsHook
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
    qtcharts
    qtdeclarative
    qtgamepad
    qtgraphicaleffects
    qtlocation
    qtmultimedia
    qtquickcontrols
    qtquickcontrols2
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
  ++ lib.optionals withSDRplay [ sdrplay ];

  cmakeFlags = [
    "-DAPT_DIR=${aptdec}"
    "-DDAB_DIR=${dab_lib}"
    "-DSGP4_DIR=${sgp4}"
    "-DSOAPYSDR_DIR=${soapysdr-with-plugins}"
    "-Wno-dev"
  ];

  meta = {
    description = "Software defined radio (SDR) software";
    homepage = "https://github.com/f4exb/sdrangel";
    license = lib.licenses.gpl3Plus;
    longDescription = ''
      SDRangel is an Open Source Qt5 / OpenGL 3.0+ SDR and signal analyzer frontend to various hardware.
    '';
    maintainers = with lib.maintainers; [ alkeryn Tungsten842 ];
    platforms = lib.platforms.unix;
  };
})

{ airspy
, boost
, cm256cc
, cmake
, codec2
, fetchFromGitHub
, fftwFloat
, glew
, hackrf
, lib
, ffmpeg
, libiio
, libopus
, libpulseaudio
, libusb1
, limesuite
, libbladeRF
, mkDerivation
, ocl-icd
, opencv3
, pkg-config
, qtcharts
, qtlocation
, qtmultimedia
, qtserialport
, qtspeech
, qtwebsockets
, rtl-sdr
, serialdv
, soapysdr-with-plugins
, uhd
}:

mkDerivation rec {
  pname = "sdrangel";
  version = "6.17.1";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
    rev = "v${version}";
    sha256 = "sha256-VWHFrgJVyI3CtLXUiG3/4/cRTD8jSdunbrro34yLKvs=";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [
    airspy
    boost
    cm256cc
    codec2
    ffmpeg
    fftwFloat
    glew
    hackrf
    libbladeRF
    libiio
    libopus
    libpulseaudio
    libusb1
    limesuite
    opencv3
    qtcharts
    qtlocation
    qtmultimedia
    qtserialport
    qtspeech
    qtwebsockets
    rtl-sdr
    serialdv
    soapysdr-with-plugins
    uhd
  ];

  cmakeFlags = [
    "-DLIBSERIALDV_INCLUDE_DIR:PATH=${serialdv}/include/serialdv"
    "-DLIMESUITE_INCLUDE_DIR:PATH=${limesuite}/include"
    "-DLIMESUITE_LIBRARY:FILEPATH=${limesuite}/lib/libLimeSuite.so"
    "-DSOAPYSDR_DIR=${soapysdr-with-plugins}"
  ];

  LD_LIBRARY_PATH = "${ocl-icd}/lib";

  meta = with lib; {
    description = "Software defined radio (SDR) software";
    longDescription = ''
      SDRangel is an Open Source Qt5 / OpenGL 3.0+ SDR and signal analyzer frontend to various hardware.
    '';
    homepage = "https://github.com/f4exb/sdrangel";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ alkeryn ];
    platforms = platforms.linux;
  };
}

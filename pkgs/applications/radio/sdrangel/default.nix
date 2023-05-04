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
, ocl-icd
, opencv3
, pkg-config
, qtcharts
, qtdeclarative
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
, sgp4
, soapysdr-with-plugins
, uhd
, wrapQtAppsHook
, zlib
}:

stdenv.mkDerivation rec {
  pname = "sdrangel";
  version = "7.13.0";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
    rev = "v${version}";
    hash = "sha256-xG41FNlMfqH5MaGVFFENP0UFEkZYiWhtpNSPh2s4Irk=";
  };

  nativeBuildInputs = [ cmake ninja pkg-config wrapQtAppsHook ];

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
    opencv3
    qtcharts
    qtdeclarative
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
  ];

  cmakeFlags = [
    "-DAPT_DIR=${aptdec}"
    "-DDAB_DIR=${dab_lib}"
    "-DSGP4_DIR=${sgp4}"
    "-DSOAPYSDR_DIR=${soapysdr-with-plugins}"
    "-Wno-dev"
  ];

  LD_LIBRARY_PATH = "${ocl-icd}/lib";

  meta = with lib; {
    description = "Software defined radio (SDR) software";
    longDescription = ''
      SDRangel is an Open Source Qt5 / OpenGL 3.0+ SDR and signal analyzer frontend to various hardware.
    '';
    homepage = "https://github.com/f4exb/sdrangel";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ alkeryn Tungsten842 ];
    platforms = platforms.unix;
  };
}

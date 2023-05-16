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
<<<<<<< HEAD
=======
, ocl-icd
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, opencv3
, pkg-config
, qtcharts
, qtdeclarative
<<<<<<< HEAD
, qtgamepad
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
, sdrplay
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
, sgp4
, soapysdr-with-plugins
, uhd
, wrapQtAppsHook
, zlib
<<<<<<< HEAD
, withSDRplay ? false
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sdrangel";
  version = "7.15.4";
=======
}:

stdenv.mkDerivation rec {
  pname = "sdrangel";
  version = "7.13.0";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
<<<<<<< HEAD
    rev = "v${finalAttrs.version}";
    hash = "sha256-oSFnoNmoXvdb5lpx/j3DVVhOfbsDZlGNZNcvud1w8Ks=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapQtAppsHook
  ];
=======
    rev = "v${version}";
    hash = "sha256-xG41FNlMfqH5MaGVFFENP0UFEkZYiWhtpNSPh2s4Irk=";
  };

  nativeBuildInputs = [ cmake ninja pkg-config wrapQtAppsHook ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

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
<<<<<<< HEAD
    qtgamepad
=======
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
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
<<<<<<< HEAD
  ]
  ++ lib.optionals withSDRplay [ sdrplay ];
=======
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

  cmakeFlags = [
    "-DAPT_DIR=${aptdec}"
    "-DDAB_DIR=${dab_lib}"
    "-DSGP4_DIR=${sgp4}"
    "-DSOAPYSDR_DIR=${soapysdr-with-plugins}"
    "-Wno-dev"
  ];

<<<<<<< HEAD
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
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)

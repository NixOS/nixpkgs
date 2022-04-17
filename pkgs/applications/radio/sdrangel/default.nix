{ airspy
, boost
, cm256cc
, cmake
, codec2
, fetchFromGitHub
, fetchpatch
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
, qtwebengine
, qtwebsockets
, rtl-sdr
, serialdv
, soapysdr-with-plugins
, uhd
}:

mkDerivation rec {
  pname = "sdrangel";
  version = "6.20.2";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
    rev = "v${version}";
    sha256 = "sha256-4RvOXC4I0njkMQqYiQODtJB2bYfw6Kt6z3Ek63BOVYg=";
    fetchSubmodules = false;
  };

  patches = [
    # Fixes a core dump bug when unloading DATV or DSD decoder, backport from v7 branch
    # Should be removed if v7 is released or backported upstream
    (fetchpatch {
      url = "https://github.com/f4exb/sdrangel/commit/98a3a76ca111652a7e6714e9231e6c42bb212a0b.patch";
      sha256 = "sha256-Fgs4u6rSUyhvYJ66ywH6PTBrj9fSWWtR9QGFb8dEEdY=";
    })
  ];

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
    qtwebengine
    qtwebsockets
    rtl-sdr
    serialdv
    soapysdr-with-plugins
    uhd
  ];

  cmakeFlags = [
    "-DDEBUG_OUTPUT=ON"
    "-DRX_SAMPLE_24BIT=ON"
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

{
airspy,
boost,
cm256cc,
cmake,
codec2,
fetchFromGitHub,
fftwFloat,
glew,
hackrf,
lib,
ffmpeg,
libiio,
libopus,
libpulseaudio,
libusb1,
limesuite,
libbladeRF,
mkDerivation,
ocl-icd,
opencv3,
pkg-config,
qtbase,
qtmultimedia,
qtserialport,
qtwebsockets,
rtl-sdr,
serialdv,
soapysdr-with-plugins,
uhd
}:

mkDerivation rec {
  pname = "sdrangel";
  version = "6.4.0";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
    rev = "v${version}";
    sha256 = "4iJoKs0BHmBR6JRFuTIqs0GW3SjhPRMPRlqdyTI38T4=";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    glew opencv3 libusb1 boost libopus limesuite ffmpeg libiio libpulseaudio
    qtbase qtwebsockets qtmultimedia rtl-sdr airspy hackrf
    fftwFloat codec2 cm256cc serialdv qtserialport
    libbladeRF uhd soapysdr-with-plugins
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ alkeryn ];
  };
}

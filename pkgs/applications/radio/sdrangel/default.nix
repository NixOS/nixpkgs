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
libav,
libiio,
libopus,
libpulseaudio,
libusb-compat-0_1,
limesuite,
mkDerivation,
ocl-icd,
opencv3,
pkgconfig,
qtbase,
qtmultimedia,
qtwebsockets,
rtl-sdr,
serialdv
}:

let

  codec2' = codec2.overrideAttrs (old: {
    src = fetchFromGitHub {
      owner = "drowe67";
      repo = "codec2";
      rev = "567346818c0d4d697773cf66d925fdb031e15668";
      sha256 = "0ngqlh2cw5grx2lg7xj8baz6p55gfhq4caggxkb4pxlg817pwbpa";
    };
  });

in mkDerivation rec {
  pname = "sdrangel";
  version = "4.11.12";

  src = fetchFromGitHub {
    owner = "f4exb";
    repo = "sdrangel";
    rev = "v${version}";
    sha256 = "0zbx0gklylk8npb3wnnmqpam0pdxl40f20i3wzwwh4gqrppxywzx";
    fetchSubmodules = false;
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [
    glew opencv3 libusb-compat-0_1 boost libopus limesuite libav libiio libpulseaudio
    qtbase qtwebsockets qtmultimedia rtl-sdr airspy hackrf
    fftwFloat codec2' cm256cc serialdv
  ];
  cmakeFlags = [
    "-DLIBSERIALDV_INCLUDE_DIR:PATH=${serialdv}/include/serialdv"
    "-DLIMESUITE_INCLUDE_DIR:PATH=${limesuite}/include"
    "-DLIMESUITE_LIBRARY:FILEPATH=${limesuite}/lib/libLimeSuite.so"
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

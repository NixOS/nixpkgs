{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  fftwSinglePrec,
}:

stdenv.mkDerivation rec {
  pname = "hackrf";
  version = "2024.02.1";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "hackrf";
    rev = "v${version}";
    sha256 = "sha256-b3nGrk2P6ZLYBSCSD7c0aIApCh3ZoVDcFftybqm4vx0=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
    fftwSinglePrec
  ];

  cmakeFlags = [
    "-DUDEV_RULES_GROUP=plugdev"
    "-DUDEV_RULES_PATH=lib/udev/rules.d"
  ];

  preConfigure = ''
    cd host
  '';

  postPatch = ''
    substituteInPlace host/cmake/modules/FindFFTW.cmake \
      --replace "find_library (FFTW_LIBRARIES NAMES fftw3)" "find_library (FFTW_LIBRARIES NAMES fftw3f)"
  '';

  meta = {
    description = "Open source SDR platform";
    homepage = "https://greatscottgadgets.com/hackrf/";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ sjmackenzie ];
  };
}

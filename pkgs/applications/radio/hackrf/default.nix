{ lib, stdenv, fetchFromGitHub, cmake, pkg-config, libusb1, fftwSinglePrec }:

stdenv.mkDerivation rec {
  pname = "hackrf";
  version = "2023.01.1";

  src = fetchFromGitHub {
    owner = "greatscottgadgets";
    repo = "hackrf";
    rev = "v${version}";
    sha256 = "sha256-zvSSCNtqHOZVlrBggjgxEyUTqTiAIAhdzUkm4Pm9b3k=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    libusb1
    fftwSinglePrec
  ];

  cmakeFlags = [ "-DUDEV_RULES_GROUP=plugdev" "-DUDEV_RULES_PATH=lib/udev/rules.d" ];

  preConfigure = ''
    cd host
  '';

  postPatch = ''
    substituteInPlace host/cmake/modules/FindFFTW.cmake \
      --replace "find_library (FFTW_LIBRARIES NAMES fftw3)" "find_library (FFTW_LIBRARIES NAMES fftw3f)"
  '';

  meta = with lib; {
    description = "An open source SDR platform";
    homepage = "https://greatscottgadgets.com/hackrf/";
    license = licenses.gpl2;
    platforms = platforms.all;
    maintainers = with maintainers; [ sjmackenzie ];
  };
}

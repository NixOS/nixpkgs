{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libusb1,
  rtl-sdr,
  fftw,
}:

stdenv.mkDerivation {
  pname = "dabtools";
  version = "20180405";

  src = fetchFromGitHub {
    owner = "Opendigitalradio";
    repo = "dabtools";
    rev = "8b0b2258b02020d314efd4d0d33a56c8097de0d1";
    hash = "sha256-VafaRsQMtcIRtz6Tr/KmykWdyKu8m2cK/IaL95Zv06I=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    rtl-sdr
    fftw
    libusb1
  ];

  #  CMake 4 is no longer retro compatible with versions < 3.5
  postPatch = ''
    substituteInPlace CMakeLists.txt src/CMakeLists.txt --replace-fail \
      "cmake_minimum_required(VERSION 2.8)" \
      "cmake_minimum_required(VERSION 3.5)"
  '';

  meta = {
    description = "Commandline tools for DAB and DAB+ digital radio broadcasts";
    homepage = "https://github.com/Opendigitalradio/dabtools";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.markuskowa ];
  };
}

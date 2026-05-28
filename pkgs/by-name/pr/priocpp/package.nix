{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  fmt,
  gtest,
  logmich,
  tinycmmc,
  jsoncpp,
  sexp-cpp,
}:

stdenv.mkDerivation {
  pname = "priocpp";
  version = "0.0.0-unstable-2025-07-21";

  src = fetchFromGitHub {
    owner = "Grumbel";
    repo = "priocpp";
    rev = "b2664449adcaed93f609e3ea1fb68f8295390ce9";
    sha256 = "sha256-tn0UNK+rQQPpSgTexOKyROOvX6ynEHFUj+gk11dlh/8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  propagatedBuildInputs = [
    fmt
    gtest
    logmich
    tinycmmc
    jsoncpp
    sexp-cpp
  ];

  cmakeFlags = [
    "-DBUILD_EXTRA=ON"
    "-DBUILD_TESTS=ON"
    "-DPRIO_USE_JSONCPP=ON"
    "-DPRIO_USE_SEXPCPP=ON"
  ];

  doCheck = true;

  meta = {
    description = "Property I/O for C++";
    maintainers = [ lib.maintainers.SchweGELBin ];
    platforms = lib.platforms.linux;
    license = lib.licenses.free;
  };
}

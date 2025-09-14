{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
}:

stdenv.mkDerivation rec {
  pname = "geographiclib";
  version = "2.5.2";

  src = fetchFromGitHub {
    owner = "geographiclib";
    repo = "geographiclib";
    tag = "v${version}";
    hash = "sha256-bFErzgjxBCtN12UNtnGPuS6bg1sI31gR7WZjawsY3Yo=";
  };

  outputs = [
    "dev"
    "doc"
    "out"
  ];

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  cmakeFlags = [
    (lib.cmakeBool "BUILD_DOCUMENTATION" true)
    (lib.cmakeFeature "CMAKE_INSTALL_LIBDIR" "lib")
  ];

  meta = {
    description = "C++ geographic library";
    longDescription = ''
      GeographicLib is a small C++ library for:
      * geodesic and rhumb line calculations
      * conversions between geographic, UTM, UPS, MGRS, geocentric, and local cartesian coordinates
      * gravity (e.g., EGM2008) and geomagnetic field (e.g., WMM2020) calculations
    '';
    homepage = "https://geographiclib.sourceforge.io/";
    license = lib.licenses.mit;
    teams = [ lib.teams.geospatial ];
    platforms = lib.platforms.unix;
  };
}

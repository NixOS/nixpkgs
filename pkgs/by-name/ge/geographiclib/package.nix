{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  doxygen,
}:

stdenv.mkDerivation rec {
  pname = "geographiclib";
  version = "2.5";

  src = fetchFromGitHub {
    owner = "geographiclib";
    repo = "geographiclib";
    tag = "v${version}";
    hash = "sha256-hFheJ6Q1GEfqPVq7t4SHN/n2JniqCQUzwl7GEVG0jgo=";
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
    maintainers = with lib.maintainers; [ sikmir ];
    platforms = lib.platforms.unix;
  };
}

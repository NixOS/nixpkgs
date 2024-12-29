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
    rev = "v${version}";
    hash = "sha256-hFheJ6Q1GEfqPVq7t4SHN/n2JniqCQUzwl7GEVG0jgo=";
  };

  nativeBuildInputs = [
    cmake
    doxygen
  ];

  cmakeFlags = [
    "-DBUILD_DOCUMENTATION=ON"
    "-DCMAKE_INSTALL_LIBDIR=lib"
  ];

  meta = with lib; {
    description = "C++ geographic library";
    longDescription = ''
      GeographicLib is a small C++ library for:
      * geodesic and rhumb line calculations
      * conversions between geographic, UTM, UPS, MGRS, geocentric, and local cartesian coordinates
      * gravity (e.g., EGM2008) and geomagnetic field (e.g., WMM2020) calculations
    '';
    homepage = "https://geographiclib.sourceforge.io/";
    license = licenses.mit;
    maintainers = with maintainers; [ sikmir ];
    platforms = platforms.unix;
  };
}

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  uhd,
  boost,
  soapysdr,
}:

stdenv.mkDerivation {
  pname = "soapyuhd";
  version = "0.4.1-unstable-2025-10-05";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyUHD";
    # version that supports cmake 4
    rev = "cf78b9ca3bddfc9263d2acb7e8afcb0036938163";
    hash = "sha256-/hJ78dUL477gX3c2kV8kUknIk01PUf+ie1Gl7Ujq1Ac=";
  };

  # Newer versions of Boost do not pull in boost::lexical_cast transitively, so
  # it must be explicitly specified.
  # Vendored from https://github.com/pothosware/SoapyUHD/pull/76
  patches = [ ./boost-lexical-cast.patch ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    uhd
    boost
    soapysdr
  ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  # SoapyUHD was originally pinned to C++14 as that was required by UHD at the
  # time, but UHD 4.10 upgrades to C++20, so we switch to that here as well.
  # https://github.com/pothosware/SoapyUHD/commit/1f7b6fa245f782e5d18453f5cbc6d9f27e6b26df
  postPatch = ''
    sed -i "s:DESTINATION .*uhd/modules:DESTINATION $out/lib/uhd/modules:" CMakeLists.txt

    substituteInPlace CMakeLists.txt --replace-fail \
      "set(CMAKE_CXX_STANDARD 14)" "set(CMAKE_CXX_STANDARD 20)"
  '';

  meta = {
    homepage = "https://github.com/pothosware/SoapyAirspy";
    description = "SoapySDR plugin for UHD devices";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.unix;
  };
}

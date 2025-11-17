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

  postPatch = ''
    sed -i "s:DESTINATION .*uhd/modules:DESTINATION $out/lib/uhd/modules:" CMakeLists.txt
  '';

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyAirspy";
    description = "SoapySDR plugin for UHD devices";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.unix;
  };
}

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
  version = "0.4.1-unstable-2026-09-25";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyUHD";
    # includes get_stream_info() overrides needed for UHD >= 4.11
    rev = "c695089c9d139f90465d2025d8dcb2ef26fa00f0";
    hash = "sha256-uGPCmjSHI8dx4//tacuHLNPwDImoacvcKHplYyNpLao=";
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

  meta = {
    homepage = "https://github.com/pothosware/SoapyUHD";
    description = "SoapySDR plugin for UHD devices";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.unix;
  };
}

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

stdenv.mkDerivation rec {
  pname = "soapyuhd";
  version = "0.4.1-unstable-2025-02-13";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyUHD";
    rev = "6b521393cc45c66770f3d4bc69eac7dda982174c";
    sha256 = "qg0mbw3S973cnok6tVx7Y38ijOQcJdHtPLi889uo7tI=";
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

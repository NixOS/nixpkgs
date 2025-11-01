{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  soapysdr,
  sdrplay,
}:

stdenv.mkDerivation rec {
  pname = "soapysdr-sdrplay3";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDRPlay3";
    rev = "soapy-sdrplay3-${version}";
    hash = "sha256-5XBOUhI/37sMfdVEb19zWU00/j+Nb30wsP5CXjJ+sJY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    soapysdr
    sdrplay
  ];

  cmakeFlags = [
    "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/"
  ];

  meta = with lib; {
    description = "Soapy SDR module for SDRplay";
    homepage = "https://github.com/pothosware/SoapySDRPlay3";
    license = licenses.mit;
    maintainers = [ maintainers.pmenke ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
}

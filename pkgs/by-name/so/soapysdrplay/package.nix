{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  soapysdr,
  sdrplay,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapysdr-sdrplay3";
  version = "0.5.2";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDRPlay3";
    rev = "soapy-sdrplay3-${finalAttrs.version}";
    hash = "sha256-5XBOUhI/37sMfdVEb19zWU00/j+Nb30wsP5CXjJ+sJY=";
  };

  patches = [ ./cmake.patch ];

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

  meta = {
    description = "Soapy SDR module for SDRplay";
    homepage = "https://github.com/pothosware/SoapySDRPlay3";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.pmenke ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ];
  };
})

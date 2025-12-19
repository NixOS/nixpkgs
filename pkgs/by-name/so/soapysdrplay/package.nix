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
    sha256 = "sha256-5XBOUhI/37sMfdVEb19zWU00/j+Nb30wsP5CXjJ+sJY=";
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
    platforms = lib.platforms.linux;
  };
})

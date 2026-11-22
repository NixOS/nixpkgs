{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libbladeRF,
  soapysdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapybladerf";
  version = "0.4.4";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyBladeRF";
    tag = "soapy-bladerf-${finalAttrs.version}";
    hash = "sha256-+7udRpQ3mdNiXlfzqc50p/fcjBvFcEYLRXCpDDYVmXs=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libbladeRF
    soapysdr
  ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = {
    homepage = "https://github.com/pothosware/SoapyBladeRF";
    description = "SoapySDR plugin for BladeRF devices";
    license = lib.licenses.lgpl21Only;
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.unix;
  };
})

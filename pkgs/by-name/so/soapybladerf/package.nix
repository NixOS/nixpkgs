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
  version = "0.4.3";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyBladeRF";
    tag = "soapy-bladerf-${finalAttrs.version}";
    hash = "sha256-kKt13/jMjb+CKmopasNFIMEgS+jOR2vB+OU5BFp10wc=";
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

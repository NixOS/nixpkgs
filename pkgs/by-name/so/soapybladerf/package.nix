{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  libbladeRF,
  soapysdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapybladerf";
  version = "0.4.2";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyBladeRF";
    rev = "soapy-bladerf-${finalAttrs.version}";
    sha256 = "sha256-lhTiu+iCdlLTY5ceND+F8HzKf2K9afuTi3cme6nGEMo=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/pothosware/SoapyBladeRF/commit/f141b61624f24a56aa3bdf7b0cc61c9fa65c26a3.patch";
      hash = "sha256-szqHbSAHiK0F83bxYnrblEBi/U7tpD0AXotYV1eTFxU=";
    })
  ];

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

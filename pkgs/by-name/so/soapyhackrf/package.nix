{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hackrf,
  soapysdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapyhackrf";
  version = "0.3.6";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyHackRF";
    tag = "soapy-hackrf-${finalAttrs.version}";
    hash = "sha256-5Cr46rfDczfUV1yLivxBYl90mqnzdHrxZZaIzuabFAE=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hackrf
    soapysdr
  ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = {
    homepage = "https://github.com/pothosware/SoapyHackRF";
    description = "SoapySDR plugin for HackRF devices";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.unix;
  };
})

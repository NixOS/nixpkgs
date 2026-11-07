{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  hackrf,
  soapysdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapyhackrf";
  version = "0.3.4";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyHackRF";
    tag = "soapy-hackrf-${finalAttrs.version}";
    hash = "sha256-fzPYHJAPX8FkFxPXpLlUagTd/NoamRX0YnxHwkbV1nI=";
  };

  patches = [
    (fetchpatch {
      url = "https://github.com/pothosware/SoapyHackRF/commit/143ff5e7e0f786e341df8846c04e8273c5183c26.patch";
      hash = "sha256-8tMN6uEWUt1sUC45kBM6WHXDd/oTFyo6u+NpVPg+z5Q=";
    })
  ];

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

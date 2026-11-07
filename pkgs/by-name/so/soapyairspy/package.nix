{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  airspy,
  soapysdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapyairspy";
  version = "0.2.1";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyAirspy";
    tag = "soapy-airspy-${finalAttrs.version}";
    hash = "sha256-Qc9IJ1Q0zBEphKoDhUiSU9DBndoRodo5hNjlP2eTkXo=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    airspy
    soapysdr
  ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = {
    homepage = "https://github.com/pothosware/SoapyAirspy";
    description = "SoapySDR plugin for Airspy devices";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ markuskowa ];
    platforms = lib.platforms.unix;
  };
})

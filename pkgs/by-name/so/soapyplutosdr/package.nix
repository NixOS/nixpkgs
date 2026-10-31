{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libad9361,
  libiio,
  libusb1,
  soapysdr,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapyplutosdr";
  version = "0.2.4";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyPlutoSDR";
    tag = "soapy-plutosdr-${finalAttrs.version}";
    hash = "sha256-KpIgQXGyVm5fo7P7SCstApSA9CR2VW4uexh4BpX0ueI=";
  };

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libad9361
    libiio
    libusb1
    soapysdr
  ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = {
    homepage = "https://github.com/pothosware/SoapyPlutoSDR";
    changelog = "https://github.com/pothosware/SoapyPlutoSDR/blob/soapy-plutosdr-${finalAttrs.version}/Changelog.txt";
    description = "SoapySDR plugin for Pluto SDR devices";
    license = lib.licenses.lgpl21;
    maintainers = with lib.maintainers; [ wucke13 ];
    platforms = lib.platforms.unix;
  };
})

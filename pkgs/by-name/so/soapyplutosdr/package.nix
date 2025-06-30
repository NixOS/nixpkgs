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
  version = "0.2.2";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyPlutoSDR";
    rev = "soapy-plutosdr-${finalAttrs.version}";
    hash = "sha256-uXKvv/QRbYknqsLGlPFxSH7KLh0CucLjq4XEFFcieWw=";
  };

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

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyPlutoSDR";
    changelog = "https://github.com/pothosware/SoapyPlutoSDR/blob/soapy-plutosdr-${finalAttrs.version}/Changelog.txt";
    description = "SoapySDR plugin for Pluto SDR devices";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ wucke13 ];
    platforms = platforms.unix;
  };
})

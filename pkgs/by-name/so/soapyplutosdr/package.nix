{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # CMake < 3.5.0 fixes. Remove as soon as https://github.com/pothosware/SoapyPlutoSDR/pull/72 is merged and we do the next version bump.
    (fetchpatch {
      url = "https://github.com/pothosware/SoapyPlutoSDR/commit/6ab50457c378e19fa53038cadb131313cde23916.patch";
      hash = "sha256-ExrcziyDmytaVosQ+em177Unh6er/2+2nLjEXg6f0vU=";
    })
    (fetchpatch {
      url = "https://github.com/pothosware/SoapyPlutoSDR/commit/4a01ddf1ae2fd0de86c6774ff35aa51f9b4f0b5a.patch";
      hash = "sha256-XgyCWSAlKqCXxH5vtijYqub6656xYkWaY6+B0dkfsGA=";
    })
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

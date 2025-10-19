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

let
  version = "0.4.2";

in
stdenv.mkDerivation {
  pname = "soapybladerf";
  inherit version;

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyBladeRF";
    rev = "soapy-bladerf-${version}";
    sha256 = "sha256-lhTiu+iCdlLTY5ceND+F8HzKf2K9afuTi3cme6nGEMo=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs = [
    libbladeRF
    soapysdr
  ];

  patches = [
    (fetchpatch {
      url = "https://github.com/pothosware/SoapyBladeRF/commit/f141b61624f24a56aa3bdf7b0cc61c9fa65c26a3.patch";
      hash = "sha256-szqHbSAHiK0F83bxYnrblEBi/U7tpD0AXotYV1eTFxU=";
    })
  ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyBladeRF";
    description = "SoapySDR plugin for BladeRF devices";
    license = licenses.lgpl21Only;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.unix;
  };
}

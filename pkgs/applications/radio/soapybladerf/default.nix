{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  libbladeRF,
  soapysdr,
  libobjc,
  IOKit,
  Security,
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
  buildInputs =
    [
      libbladeRF
      soapysdr
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libobjc
      IOKit
      Security
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

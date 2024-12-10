{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hackrf,
  soapysdr,
  libobjc,
  IOKit,
  Security,
}:

let
  version = "0.3.4";

in
stdenv.mkDerivation {
  pname = "soapyhackrf";
  inherit version;

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyHackRF";
    rev = "soapy-hackrf-${version}";
    sha256 = "sha256-fzPYHJAPX8FkFxPXpLlUagTd/NoamRX0YnxHwkbV1nI=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs =
    [
      hackrf
      soapysdr
    ]
    ++ lib.optionals stdenv.isDarwin [
      libobjc
      IOKit
      Security
    ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyHackRF";
    description = "SoapySDR plugin for HackRF devices";
    license = licenses.mit;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.unix;
  };
}

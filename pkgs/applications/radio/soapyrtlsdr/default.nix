{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  rtl-sdr,
  soapysdr,
  libobjc,
  IOKit,
  Security,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "soapyrtlsdr";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRTLSDR";
    rev = "soapy-rtl-sdr-${finalAttrs.version}";
    sha256 = "sha256-IapdrBE8HhibY52Anm76/mVAoA0GghwnRCxxfGkyLTw=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];
  buildInputs =
    [
      rtl-sdr
      soapysdr
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      libobjc
      IOKit
      Security
    ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyRTLSDR";
    description = "SoapySDR plugin for RTL-SDR devices";
    license = licenses.mit;
    maintainers = with maintainers; [
      ragge
      luizribeiro
    ];
    platforms = platforms.unix;
  };
})

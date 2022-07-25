{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, rtl-sdr, soapysdr, libobjc, IOKit, Security
} :

let
  version = "0.3.3";

in stdenv.mkDerivation {
  pname = "soapyrtlsdr";
  inherit version;

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRTLSDR";
    rev = "soapy-rtl-sdr-${version}";
    sha256 = "sha256-IapdrBE8HhibY52Anm76/mVAoA0GghwnRCxxfGkyLTw=";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ rtl-sdr soapysdr ]
    ++ lib.optionals stdenv.isDarwin [ libobjc IOKit Security ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyRTLSDR";
    description = "SoapySDR plugin for RTL-SDR devices";
    license = licenses.mit;
    maintainers = with maintainers; [ ragge ];
    platforms = platforms.unix;
  };
}

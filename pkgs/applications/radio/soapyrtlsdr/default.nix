{ lib, stdenv, fetchFromGitHub, cmake, pkg-config
, rtl-sdr, soapysdr
} :

let
  version = "0.3.0";

in stdenv.mkDerivation {
  pname = "soapyrtlsdr";
  inherit version;

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRTLSDR";
    rev = "soapy-rtlsdr-${version}";
    sha256 = "15j0s7apbg9cjr6rcbr058kl0r3szwzf00ixcbykxb77fh7c6r9w";
  };

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [ rtl-sdr soapysdr ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyRTLSDR";
    description = "SoapySDR plugin for RTL-SDR devices";
    license = licenses.mit;
    maintainers = with maintainers; [ ragge ];
    platforms = platforms.unix;
  };
}

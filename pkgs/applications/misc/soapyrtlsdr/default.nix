{ stdenv, fetchFromGitHub, cmake, pkgconfig
, rtl-sdr, soapysdr
} :

let
  version = "0.2.5";

in stdenv.mkDerivation {
  name = "soapyrtlsdr-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRTLSDR";
    rev = "soapy-rtlsdr-${version}";
    sha256 = "1wyghfqq3vcbjn5w06h5ik62m6555inrlkyrsnk2r78865xilkv3";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ rtl-sdr soapysdr ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/pothosware/SoapyRTLSDR;
    description = "SoapySDR plugin for RTL-SDR devices";
    license = licenses.mit;
    maintainers = with maintainers; [ ragge ];
    platforms = platforms.linux;
  };
}

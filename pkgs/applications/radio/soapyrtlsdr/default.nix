{ stdenv, fetchFromGitHub, cmake, pkgconfig
, rtl-sdr, soapysdr
} :

let
  version = "0.3.0";

in stdenv.mkDerivation {
  name = "soapyrtlsdr-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRTLSDR";
    rev = "soapy-rtlsdr-${version}";
    sha256 = "15j0s7apbg9cjr6rcbr058kl0r3szwzf00ixcbykxb77fh7c6r9w";
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

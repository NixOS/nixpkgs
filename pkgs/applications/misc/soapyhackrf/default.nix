{ stdenv, fetchFromGitHub, cmake, pkgconfig
, hackrf, soapysdr
} :

let
  version = "0.3.2";

in stdenv.mkDerivation {
  name = "soapyhackrf-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyHackRF";
    rev = "soapy-hackrf-${version}";
    sha256 = "1sgx2nk8yrzfwisjfs9mw0xwc47bckzi17p42s2pbv7zcxzpb66p";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ hackrf soapysdr ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/pothosware/SoapyHackRF;
    description = "SoapySDR plugin for HackRF devices";
    license = licenses.mit;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}

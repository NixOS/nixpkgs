{ stdenv, fetchFromGitHub, cmake, pkgconfig
, hackrf, soapysdr
} :

let
  version = "0.3.3";

in stdenv.mkDerivation {
  name = "soapyhackrf-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyHackRF";
    rev = "soapy-hackrf-${version}";
    sha256 = "1awn89z462500gb3fjb7x61b1znkjri9n1d39bqfip1qk4s11pxc";
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

{ stdenv, fetchFromGitHub, cmake
, airspy, soapysdr
} :

let
  version = "0.1.1";

in stdenv.mkDerivation {
  name = "soapyairspy-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyAirspy";
    rev = "soapy-airspy-${version}";
    sha256 = "072vc9619s9f22k7639krr1p2418cmhgm44yhzy7x9dzapc43wvk";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ airspy soapysdr ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/pothosware/SoapyAirspy;
    description = "SoapySDR plugin for Airspy devices";
    license = licenses.mit;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}

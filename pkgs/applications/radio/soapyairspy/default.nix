{ lib, stdenv, fetchFromGitHub, cmake
, airspy, soapysdr
, libobjc, IOKit, Security
} :

stdenv.mkDerivation rec {
  pname = "soapyairspy";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyAirspy";
    rev = "soapy-airspy-${version}";
    sha256 = "0g23yybnmq0pg2m8m7dbhif8lw0hdsmnnjym93fdyxfk5iln7fsc";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ airspy soapysdr ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [ libobjc IOKit Security ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyAirspy";
    description = "SoapySDR plugin for Airspy devices";
    license = licenses.mit;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.unix;
  };
}

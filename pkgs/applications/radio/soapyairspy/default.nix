{ lib, stdenv, fetchFromGitHub, cmake
, airspy, soapysdr
} :

let
  version = "0.1.2";

in stdenv.mkDerivation {
  pname = "soapyairspy";
  inherit version;

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyAirspy";
    rev = "soapy-airspy-${version}";
    sha256 = "061r77vs6ywxbxfif12y6v5xkz6gcvbz9k060q12vmdh6sisdwk2";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ airspy soapysdr ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with lib; {
    homepage = "https://github.com/pothosware/SoapyAirspy";
    description = "SoapySDR plugin for Airspy devices";
    license = licenses.mit;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}

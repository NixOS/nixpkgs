{ stdenv, fetchFromGitHub, cmake, pkgconfig
, libbladeRF, soapysdr
} :

let
  version = "0.4.0";

in stdenv.mkDerivation {
  name = "soapybladerf-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyBladeRF";
    rev = "soapy-bladerf-${version}";
    sha256 = "1gf1azfydw033nlg2bgs9cbsbp9npjdrgjwlsffn0d9x0qbgxjqp";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ libbladeRF soapysdr ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];


  meta = with stdenv.lib; {
    homepage = https://github.com/pothosware/SoapyBladeRF;
    description = "SoapySDR plugin for BladeRF devices";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}

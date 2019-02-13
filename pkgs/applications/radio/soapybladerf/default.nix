{ stdenv, fetchFromGitHub, cmake, pkgconfig
, libbladeRF, soapysdr
} :

let
  version = "0.4.1";

in stdenv.mkDerivation {
  name = "soapybladerf-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyBladeRF";
    rev = "soapy-bladerf-${version}";
    sha256 = "02wh09850vinqg248fw4lxmx7y857cqmnnb8jm9zhyrsggal0hki";
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

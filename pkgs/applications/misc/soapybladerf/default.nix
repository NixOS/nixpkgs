{ stdenv, fetchFromGitHub, cmake, pkgconfig
, libbladeRF, soapysdr
} :

let
  version = "0.3.5";

in stdenv.mkDerivation {
  name = "soapybladerf-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyBladeRF";
    rev = "soapy-bladerf-${version}";
    sha256 = "1n7vy6y8k1smq3l729npxbhxbnrc79gz06dxkibsihz4k8sddkrg";
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

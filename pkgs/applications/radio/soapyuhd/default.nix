{ stdenv, fetchFromGitHub, cmake, pkgconfig
, uhd, boost, soapysdr
} :

let
  version = "0.3.6";

in stdenv.mkDerivation {
  pname = "soapyuhd";
  inherit version;

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyUHD";
    rev = "soapy-uhd-${version}";
    sha256 = "11kp5iv21k8lqwjjydzqmcxdgpm6yicw6d3jhzvcvwcavd41crs7";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ uhd boost soapysdr ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  postPatch = ''
    sed -i "s:DESTINATION .*uhd/modules:DESTINATION $out/lib/uhd/modules:" CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    homepage = "https://github.com/pothosware/SoapyAirspy";
    description = "SoapySDR plugin for UHD devices";
    license = licenses.gpl3;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}

{ stdenv, fetchFromGitHub, cmake, pkgconfig
, uhd, boost, soapysdr
} :

let
  version = "0.3.4";

in stdenv.mkDerivation {
  name = "soapyuhd-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyUHD";
    rev = "soapy-uhd-${version}";
    sha256 = "1da7cjcvfdqhgznm7x14s1h7lwz5lan1b48akw445ah1vxwvh4hl";
  };

  nativeBuildInputs = [ cmake pkgconfig ];
  buildInputs = [ uhd boost soapysdr ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  postPatch = ''
    sed -i "s:DESTINATION .*uhd/modules:DESTINATION $out/lib/uhd/modules:" CMakeLists.txt
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/pothosware/SoapyAirspy;
    description = "SoapySDR plugin for UHD devices";
    license = licenses.gpl3;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}

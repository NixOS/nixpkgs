{ stdenv, fetchFromGitHub, cmake, pkgconfig
, uhd, boost, soapysdr
} :

let
  version = "0.3.5";

in stdenv.mkDerivation {
  name = "soapyuhd-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyUHD";
    rev = "soapy-uhd-${version}";
    sha256 = "07cr4zk42d0l5g03wm7dzl5lmqr104hmzp1fdjqa1z7xq4v9c9b1";
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

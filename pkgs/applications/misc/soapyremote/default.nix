{ stdenv, fetchFromGitHub, cmake, soapysdr, avahi }:

let
  version = "0.5.0";

in stdenv.mkDerivation {
  name = "soapyremote-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRemote";
    rev = "soapy-remote-${version}";
    sha256 = "1lyjhf934zap61ky7rbk46bp8s8sjk8sgdyszhryfyf571jv9b2i";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ soapysdr avahi ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/pothosware/SoapyRemote;
    description = "SoapySDR plugin for remote access to SDRs";
    license = licenses.boost;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}

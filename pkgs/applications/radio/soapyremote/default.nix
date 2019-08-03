{ stdenv, fetchFromGitHub, cmake, soapysdr, avahi }:

let
  version = "0.5.1";

in stdenv.mkDerivation {
  name = "soapyremote-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRemote";
    rev = "soapy-remote-${version}";
    sha256 = "1qlpjg8mh564q26mni8g6bb8w9nj7hgcq86278fszxpwpnk3jsvk";
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

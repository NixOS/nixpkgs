{ stdenv, fetchFromGitHub, cmake, soapysdr }:

let
  version = "0.4.3";

in stdenv.mkDerivation {
  name = "soapyremote-${version}";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRemote";
    rev = "d07f43863b1ef79252f8029cfb5947220f21311d";
    sha256 = "0i101dfqq0aawybv0qyjgsnhk39dc4q6z6ys2gsvwjhpf3d48aw0";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ soapysdr ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with stdenv.lib; {
    homepage = https://github.com/pothosware/SoapyRemote;
    description = "SoapySDR plugin for remote access to SDRs";
    license = licenses.boost;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}

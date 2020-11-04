{ stdenv, fetchFromGitHub, cmake, soapysdr, avahi }:

let
  version = "0.5.2";

in stdenv.mkDerivation {
  pname = "soapyremote";
  inherit version;

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapyRemote";
    rev = "soapy-remote-${version}";
    sha256 = "124sy9v08fm51ds1yzrxspychn34y0rl6y48mzariianazvzmfax";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ soapysdr avahi ];

  cmakeFlags = [ "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/" ];

  meta = with stdenv.lib; {
    homepage = "https://github.com/pothosware/SoapyRemote";
    description = "SoapySDR plugin for remote access to SDRs";
    license = licenses.boost;
    maintainers = with maintainers; [ markuskowa ];
    platforms = platforms.linux;
  };
}

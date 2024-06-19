{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, soapysdr, sdrplay }:

stdenv.mkDerivation rec {
  pname = "soapysdr-sdrplay3";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDRPlay3";
    rev = "soapy-sdrplay3-${version}";
    sha256 = "sha256-WMcAw0uR2o2SrQR4mBtdVEZlJ/ZXRqwo6zMJNsB/5U4=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ soapysdr sdrplay ];

  cmakeFlags = [
    "-DSoapySDR_DIR=${soapysdr}/share/cmake/SoapySDR/"
  ];

  meta = with lib; {
    description = "Soapy SDR module for SDRplay";
    homepage = "https://github.com/pothosware/SoapySDRPlay3";
    license = licenses.mit;
    maintainers = [ maintainers.pmenke ];
    platforms = platforms.linux;
  };
}

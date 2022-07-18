{ stdenv, lib, fetchFromGitHub, cmake, pkg-config, soapysdr, sdrplay }:

stdenv.mkDerivation {
  pname = "soapysdr-sdrplay3";
  version = "unstable-2021-04-25";

  src = fetchFromGitHub {
    owner = "pothosware";
    repo = "SoapySDRPlay3";
    rev = "e6fdb719b611b1dfb7f26c56a4df1e241bd10129";
    sha256 = "0rrylp3ikrva227hjy60v4n6d6yvdavjsad9kszw9s948mwiashi";
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

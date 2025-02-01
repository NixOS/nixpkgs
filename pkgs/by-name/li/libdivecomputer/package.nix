{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libdivecomputer";
  version = "0.8.0";

  src = fetchurl {
    url = "https://www.libdivecomputer.org/releases/${pname}-${version}.tar.gz";
    sha256 = "sha256-J17M55I2RO1YH6q53LTxpprSUbzrByHE5fhftjFheg4=";
  };

  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "http://www.libdivecomputer.org";
    description = "Cross-platform and open source library for communication with dive computers from various manufacturers";
    mainProgram = "dctool";
    maintainers = [ maintainers.mguentner ];
    license = licenses.lgpl21;
    platforms = platforms.all;
  };
}

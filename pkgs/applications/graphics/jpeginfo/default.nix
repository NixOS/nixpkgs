{ lib, stdenv, fetchurl, libjpeg }:

stdenv.mkDerivation rec {
  pname = "jpeginfo";
  version = "1.7.0";

  src = fetchurl {
    url = "https://www.kokkonen.net/tjko/src/${pname}-${version}.tar.gz";
    sha256 = "sha256-3JhQg0SNlwfULkm+2CaiR8Db2mkTyHDppdm/fHSTllk=";
  };

  buildInputs = [ libjpeg ];

  meta = with lib; {
    description = "Prints information and tests integrity of JPEG/JFIF files";
    homepage = "https://www.kokkonen.net/tjko/projects.html";
    license = licenses.gpl2Plus;
    maintainers = [ maintainers.bjornfor ];
    platforms = platforms.all;
  };
}

{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "sdparm";
  version = "1.12";

  src = fetchurl {
    url = "https://sg.danny.cz/sg/p/${pname}-${version}.tar.xz";
    sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
  };

  meta = with lib; {
    homepage = "http://sg.danny.cz/sg/sdparm.html";
    description = "Utility to access SCSI device parameters";
    license = licenses.bsd3;
    platforms = with platforms; linux;
  };
}

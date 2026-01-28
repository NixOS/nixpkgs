{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "sdparm";
  version = "1.12";

  src = fetchurl {
    url = "http://sg.danny.cz/sg/p/${pname}-${version}.tar.xz";
    sha256 = "sha256-xMnvr9vrZi4vlxJwfsSQkyvU0BC7ESmueplSZUburb4=";
  };

  outputs = [
    "out"
    "man"
  ];

  meta = {
    homepage = "http://sg.danny.cz/sg/sdparm.html";
    description = "Utility to access SCSI device parameters";
    license = lib.licenses.bsd3;
    platforms = with lib.platforms; linux;
  };
}

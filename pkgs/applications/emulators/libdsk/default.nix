{ lib, stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "libdsk";
  version = "1.5.19";

  src = fetchurl {
    url = "https://www.seasip.info/Unix/LibDsk/${pname}-${version}.tar.gz";
    sha256 = "sha256-W8w5o9rK/yCipQnfn4gMOwDZ+9WeV3G53q5h2XlevkE=";
  };

  meta = with lib; {
    description = "Library for accessing discs and disc image files";
    homepage = "http://www.seasip.info/Unix/LibDsk/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
  };
}

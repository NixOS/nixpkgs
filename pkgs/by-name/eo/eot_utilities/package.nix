{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
}:

stdenv.mkDerivation rec {
  pname = "eot_utilities";
  version = "1.1";

  src = fetchurl {
    url = "https://www.w3.org/Tools/eot-utils/eot-utilities-${version}.tar.gz";
    sha256 = "0cb41riabss23hgfg7vxhky09d6zqwjy1nxdvr3l2bh5qzd4kvaf";
  };

  nativeBuildInputs = [ pkg-config ];

  meta = {
    homepage = "https://www.w3.org/Tools/eot-utils/";
    description = "Create Embedded Open Type from OpenType or TrueType font";
    license = lib.licenses.w3c;
    platforms = with lib.platforms; unix;
  };
}

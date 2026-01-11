{
  stdenv,
  fetchurl,
  lib,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "courier-unicode";
  version = "2.4.0";

  src = fetchurl {
    url = "mirror://sourceforge/courier/courier-unicode/${version}/courier-unicode-${version}.tar.bz2";
    hash = "sha256-6Ay88OOmzC56Z+waGDDWxOiqD/aXcy7B0R5UTg5kVw8=";
  };

  nativeBuildInputs = [
    perl
  ];

  outputs = [
    "out"
    "dev"
  ];

  meta = {
    homepage = "http://www.courier-mta.org/unicode/";
    description = "Courier Unicode Library is used by most other Courier packages";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}

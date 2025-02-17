{
  stdenv,
  fetchurl,
  lib,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "courier-unicode";
  version = "2.3.1";

  src = fetchurl {
    url = "mirror://sourceforge/courier/courier-unicode/${version}/courier-unicode-${version}.tar.bz2";
    sha256 = "sha256-uD7mRqR8Kp1pL7bvuThWRmjDLsF51PrAwH6s6KG4/JE=";
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
    description = "The Courier Unicode Library is used by most other Courier packages";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}

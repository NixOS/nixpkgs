{
  stdenv,
  fetchurl,
  lib,
  perl,
}:

stdenv.mkDerivation rec {
  pname = "courier-unicode";
  version = "2.3.2";

  src = fetchurl {
    url = "mirror://sourceforge/courier/courier-unicode/${version}/courier-unicode-${version}.tar.bz2";
    sha256 = "sha256-tkXS8AqrvGgjIO3mlspQIBJm9xChvOxKxQQmlcmef2k=";
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

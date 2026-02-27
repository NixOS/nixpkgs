{
  stdenv,
  fetchurl,
  lib,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "courier-unicode";
  version = "2.5.0";

  src = fetchurl {
    url = "mirror://sourceforge/courier/courier-unicode/${finalAttrs.version}/courier-unicode-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Xsp6U2UWEg745d5gFOaQcRvGs/saG9V9LxkDxU3ts+A=";
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
})

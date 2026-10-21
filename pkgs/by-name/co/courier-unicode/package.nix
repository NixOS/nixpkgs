{
  stdenv,
  fetchurl,
  lib,
  perl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "courier-unicode";
  version = "2.6.0";

  src = fetchurl {
    url = "mirror://sourceforge/courier/courier-unicode/${finalAttrs.version}/courier-unicode-${finalAttrs.version}.tar.bz2";
    hash = "sha256-Cu0jScW2LeDTPM+MI1J6rkHa+VoDyAVMiN5Prvjaigg=";
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

{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ccd2iso";
  version = "0.3";

  src = fetchurl {
    url = "mirror://sourceforge/ccd2iso/ccd2iso-${finalAttrs.version}.tar.gz";
    sha256 = "1z000zi7hpr2h9cabj6hzf3n6a6gd6glmm8nn36v4b8i4vzbhx7q";
  };

  patches = [
    ./include.patch
  ];

  meta = {
    description = "CloneCD to ISO converter";
    homepage = "https://sourceforge.net/projects/ccd2iso/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
    mainProgram = "ccd2iso";
  };
})

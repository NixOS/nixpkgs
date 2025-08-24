{
  lib,
  gccStdenv,
  fetchurl,
  fetchpatch,
  zlib,
  ncurses,
}:

let
  stdenv = gccStdenv;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "aewan";
  version = "1.0.01";

  src = fetchurl {
    url = "mirror://sourceforge/aewan/aewan-${finalAttrs.version}.tar.gz";
    hash = "sha256-UmbexeGF5TC3klIoIcl9+l+eOJLQ3KXogdDDDOrCGBc=";
  };

  patches = [
    # Pull patch pending upstream inclusion:
    #  https://sourceforge.net/p/aewan/bugs/13/
    (fetchpatch {
      url = "https://sourceforge.net/p/aewan/bugs/13/attachment/aewan-cvs-ncurses-6.3.patch";
      hash = "sha256-l+RB3JsUdrXMnzII39ytL+1q+Y1b7U3P8KWZNmiY910=";
      # patch is in CVS diff format, add 'a/' prefix
      extraPrefix = "";
    })
    # https://sourceforge.net/p/aewan/bugs/14/
    (fetchpatch {
      url = "https://sourceforge.net/p/aewan/bugs/14/attachment/aewan-1.0.01-fix-incompatible-function-pointer-types.patch";
      hash = "sha256-NlnsOe/OCMXCrehBq20e0KOMcWt5rUv9fIvu9eoOMqw=";
    })
    # https://sourceforge.net/p/aewan/bugs/16/
    (fetchpatch {
      url = "https://sourceforge.net/p/aewan/bugs/16/attachment/implicit-function-declaration.patch";
      hash = "sha256-RWFJRDaYoiQySkB2L09JHSX90zgIJ9q16IrPhg03Ruc=";
      # patch is in CVS diff format, add 'a/' prefix
      extraPrefix = "";
    })
  ];

  buildInputs = [
    zlib
    ncurses
  ];

  meta = {
    description = "Ascii-art Editor Without A Name";
    homepage = "https://aewan.sourceforge.net/";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
  };
})

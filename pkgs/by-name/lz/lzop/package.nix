{
  lib,
  stdenv,
  fetchurl,
  lzo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "lzop";
  version = "1.04";

  src = fetchurl {
    url = "https://www.lzop.org/download/lzop-${finalAttrs.version}.tar.gz";
    sha256 = "0h9gb8q7y54m9mvy3jvsmxf21yx8fc3ylzh418hgbbv0i8mbcwky";
  };

  buildInputs = [ lzo ];

  meta = {
    homepage = "http://www.lzop.org";
    description = "Fast file compressor";
    maintainers = [ ];
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.unix;
    mainProgram = "lzop";
  };
})

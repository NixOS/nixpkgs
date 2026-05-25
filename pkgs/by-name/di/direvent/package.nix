{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "direvent";
  version = "5.4";

  src = fetchurl {
    url = "mirror://gnu/direvent/direvent-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-HbvGGSqrZ+NFclFIYD1XDGooKDgMlkIVdir5FSTXlbo=";
  };

  meta = {
    description = "Directory event monitoring daemon";
    mainProgram = "direvent";
    homepage = "https://www.gnu.org.ua/software/direvent/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ puffnfresh ];
  };
})

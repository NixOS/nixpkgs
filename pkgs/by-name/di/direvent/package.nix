{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "direvent";
  version = "5.4";

  src = fetchurl {
    url = "mirror://gnu/direvent/direvent-${version}.tar.gz";
    sha256 = "sha256-HbvGGSqrZ+NFclFIYD1XDGooKDgMlkIVdir5FSTXlbo=";
  };

<<<<<<< HEAD
  meta = {
    description = "Directory event monitoring daemon";
    mainProgram = "direvent";
    homepage = "https://www.gnu.org.ua/software/direvent/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ puffnfresh ];
=======
  meta = with lib; {
    description = "Directory event monitoring daemon";
    mainProgram = "direvent";
    homepage = "https://www.gnu.org.ua/software/direvent/";
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
    maintainers = with maintainers; [ puffnfresh ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

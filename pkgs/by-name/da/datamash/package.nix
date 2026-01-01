{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "datamash";
  version = "1.9";

  src = fetchurl {
    url = "mirror://gnu/datamash/datamash-${version}.tar.gz";
    sha256 = "sha256-84Lr2gNlDdZ5Fh91j5wKbMkpMhNDjUp3qO2jJarLh9I=";
  };

<<<<<<< HEAD
  meta = {
    description = "Command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = "https://www.gnu.org/software/datamash/";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pSub ];
=======
  meta = with lib; {
    description = "Command-line program which performs basic numeric,textual and statistical operations on input textual data files";
    homepage = "https://www.gnu.org/software/datamash/";
    license = licenses.gpl3Plus;
    platforms = platforms.all;
    maintainers = with maintainers; [ pSub ];
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

}

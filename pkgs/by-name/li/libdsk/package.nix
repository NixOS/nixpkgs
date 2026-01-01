{
  lib,
  stdenv,
  fetchurl,
}:

stdenv.mkDerivation rec {
  pname = "libdsk";
  version = "1.5.22";

  src = fetchurl {
    url = "https://www.seasip.info/Unix/LibDsk/${pname}-${version}.tar.gz";
    sha256 = "sha256-gQ+AC8x2ZfTBs14ZquyzXzcptxKtHYBxBQWbS9sc8Ek=";
  };

<<<<<<< HEAD
  meta = {
    description = "Library for accessing discs and disc image files";
    homepage = "http://www.seasip.info/Unix/LibDsk/";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
    platforms = lib.platforms.unix;
=======
  meta = with lib; {
    description = "Library for accessing discs and disc image files";
    homepage = "http://www.seasip.info/Unix/LibDsk/";
    license = licenses.gpl2Plus;
    maintainers = [ ];
    platforms = platforms.unix;
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };
}

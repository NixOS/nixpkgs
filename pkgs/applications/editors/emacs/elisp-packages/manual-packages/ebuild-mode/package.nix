{
  lib,
  melpaBuild,
  fetchzip,
}:

melpaBuild rec {
  pname = "ebuild-mode";
<<<<<<< HEAD
  version = "1.80";

  src = fetchzip {
    url = "https://gitweb.gentoo.org/proj/ebuild-mode.git/snapshot/ebuild-mode-${version}.tar.bz2";
    hash = "sha256-pQ177zp0UTk9Koq+yhgaGIeFziV7KFng+Z6sAZs7qzY=";
=======
  version = "1.79";

  src = fetchzip {
    url = "https://gitweb.gentoo.org/proj/ebuild-mode.git/snapshot/ebuild-mode-${version}.tar.bz2";
    hash = "sha256-FV9e6QF85yPnowfmseo53/Q36W3wlOgTG0/X4r7OHiI=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
  };

  meta = {
    homepage = "https://gitweb.gentoo.org/proj/ebuild-mode.git/";
    description = "Major modes for Gentoo package files";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
}

{
  lib,
  melpaBuild,
  fetchzip,
}:

melpaBuild rec {
  pname = "ebuild-mode";
  version = "1.78";

  src = fetchzip {
    url = "https://gitweb.gentoo.org/proj/ebuild-mode.git/snapshot/ebuild-mode-${version}.tar.bz2";
    hash = "sha256-vpNjhW3U/b+A4O78vYKoMN0Gutd6fRcB4wb3dz1z2Cc=";
  };

  meta = {
    homepage = "https://gitweb.gentoo.org/proj/ebuild-mode.git/";
    description = "Major modes for Gentoo package files";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
}

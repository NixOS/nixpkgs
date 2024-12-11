{
  lib,
  melpaBuild,
  fetchzip,
}:

melpaBuild rec {
  pname = "ebuild-mode";
  version = "1.76";

  src = fetchzip {
    url = "https://gitweb.gentoo.org/proj/ebuild-mode.git/snapshot/ebuild-mode-${version}.tar.bz2";
    hash = "sha256-o964/Sk33PzyNm2+yoz7oAhw1M0gYwggaYSukuo9ALg=";
  };

  meta = {
    homepage = "https://gitweb.gentoo.org/proj/ebuild-mode.git/";
    description = "Major modes for Gentoo package files";
    license = lib.licenses.gpl2Plus;
    maintainers = with lib.maintainers; [ ];
  };
}

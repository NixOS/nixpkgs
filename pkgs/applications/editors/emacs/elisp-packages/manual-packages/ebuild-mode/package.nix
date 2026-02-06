{
  lib,
  melpaBuild,
  fetchzip,
}:

melpaBuild rec {
  pname = "ebuild-mode";
  version = "1.81";

  src = fetchzip {
    url = "https://gitweb.gentoo.org/proj/ebuild-mode.git/snapshot/ebuild-mode-${version}.tar.bz2";
    hash = "sha256-b+59Ec+NOHvFgbFOmnsvGjnq392VR1JCsPx/ORSdffo=";
  };

  meta = {
    homepage = "https://gitweb.gentoo.org/proj/ebuild-mode.git/";
    description = "Major modes for Gentoo package files";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
}

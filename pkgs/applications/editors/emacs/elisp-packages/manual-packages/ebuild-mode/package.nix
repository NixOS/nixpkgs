{
  lib,
  melpaBuild,
  fetchzip,
}:

melpaBuild (finalAttrs: {
  pname = "ebuild-mode";
  version = "1.86";

  src = fetchzip {
    url = "https://gitweb.gentoo.org/proj/ebuild-mode.git/snapshot/ebuild-mode-${finalAttrs.version}.tar.bz2";
    hash = "sha256-wuUZce+9VE5pthm6QPrPJFUGML6Tuv2mnY9cqkSFZo8=";
  };

  meta = {
    homepage = "https://gitweb.gentoo.org/proj/ebuild-mode.git/";
    description = "Major modes for Gentoo package files";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})

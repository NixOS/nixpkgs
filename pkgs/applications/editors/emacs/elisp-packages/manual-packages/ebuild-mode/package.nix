{
  lib,
  melpaBuild,
  fetchzip,
}:

melpaBuild (finalAttrs: {
  pname = "ebuild-mode";
  version = "1.88";

  src = fetchzip {
    url = "https://gitweb.gentoo.org/proj/ebuild-mode.git/snapshot/ebuild-mode-${finalAttrs.version}.tar.bz2";
    hash = "sha256-DsMBQS8TN2Zk4s5xBSFcM7YjsLVUZjvwdZmBLYiF7sg=";
  };

  meta = {
    homepage = "https://gitweb.gentoo.org/proj/ebuild-mode.git/";
    description = "Major modes for Gentoo package files";
    license = lib.licenses.gpl2Plus;
    maintainers = [ ];
  };
})

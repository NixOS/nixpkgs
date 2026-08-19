{
  lib,
  stdenv,
  fetchurl,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "autoconf-archive";
  version = "2024.10.16";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${finalAttrs.version}.tar.xz";
    hash = "sha256-e81dABkW86UO10NvT3AOPSsbrePtgDIZxZLWJQKlc2M=";
  };

  patches = [
    # cherry-picked changes from
    # https://git.savannah.gnu.org/gitweb/?p=autoconf-archive.git;a=commit;h=fadde164479a926d6b56dd693ded2a4c36ed89f0
    # can be removed on next release
    ./0001-ax_check_gl.m4-properly-quote-m4_fatal.patch
    ./0002-ax_check_glx.m4-properly-quote-m4_fatal.patch
    ./0003-ax_switch_flags.m4-properly-quote-m4_fatal.patch
  ];

  strictDeps = true;
  enableParallelBuilding = true;

  buildInputs = [ xz ];

  meta = {
    description = "Archive of autoconf m4 macros";
    homepage = "https://www.gnu.org/software/autoconf-archive/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
})

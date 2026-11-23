{
  lib,
  stdenv,
  fetchurl,
  xz,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "autoconf-archive";
  version = "2026.11.11";

  src = fetchurl {
    url = "mirror://gnu/autoconf-archive/autoconf-archive-${finalAttrs.version}.tar.xz";
    hash = "sha256-LBjxXis7t54JYisnOR3wfYYIzp8H+/x8EUP6aDiRqyY=";
  };

  strictDeps = true;
  enableParallelBuilding = true;

  buildInputs = [ xz ];

  __structuredAttrs = true;

  meta = {
    description = "Archive of autoconf m4 macros";
    homepage = "https://www.gnu.org/software/autoconf-archive/";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.unix;
  };
})

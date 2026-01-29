{
  lib,
  stdenv,
  fetchgit,
  cairo,
  expat,
  guile,
  guile-lib,
  pkg-config,
  autoconf,
  automake,
  texinfo,
  gettext,
}:

stdenv.mkDerivation {
  pname = "guile-cairo-next";
  version = "1.11.2-unstable-2026-01-05";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/git/guile-cairo.git";
    hash = "sha256-MdXqMl0seOoL8muKOOrR5h4arpCeTunNnrHCEAD+nI4=";
    rev = "399fbb3f9cb80dca2fefd2fceaedde4c8e75deee";
  };

  nativeBuildInputs = [
    autoconf
    automake
    texinfo
    pkg-config
    gettext
  ];
  buildInputs = [
    cairo
    expat
    guile
  ];

  preConfigure = ''
    cp ${gettext}/share/gettext/m4/lib-{ld,link,prefix}.m4 m4
    autoreconf -fvi
  '';

  enableParallelBuilding = true;

  doCheck = false; # Cannot find unit-test module from guile-lib
  nativeCheckInputs = [ guile-lib ];

  meta = {
    homepage = "https://www.nongnu.org/guile-cairo/";
    description = "Cairo bindings for GNU Guile";
    longDescription = ''
      Guile-Cairo wraps the Cairo graphics library for Guile Scheme.

      Guile-Cairo is complete, wrapping almost all of the Cairo API.  It is API
      stable, providing a firm base on which to do graphics work.  Finally, and
      importantly, it is pleasant to use.  You get a powerful and well
      maintained graphics library with all of the benefits of Scheme: memory
      management, exceptions, macros, and a dynamic programming environment.
    '';
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ mobid ];
    platforms = guile.meta.platforms;
  };
}

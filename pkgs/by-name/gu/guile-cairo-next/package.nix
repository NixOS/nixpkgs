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
  version = "1.11.2-next";

  src = fetchgit {
    url = "https://git.savannah.gnu.org/git/guile-cairo.git";
    rev = "fa2ff12e5e01966d5dcd8cfb7d5f29324b814223";
    hash = "sha256-yrI4VjMSFVvtxtY+JLrDXAYfCUAM3UkAFBSW5p8F5g8=";
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

  meta = with lib; {
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
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ mobid ];
    platforms = guile.meta.platforms;
  };
}

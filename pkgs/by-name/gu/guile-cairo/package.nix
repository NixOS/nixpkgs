{
  lib,
  autoreconfHook,
  cairo,
  expat,
  fetchFromSavannah,
  guile,
  guile-lib,
  pkg-config,
  stdenv,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-cairo";
  version = "1.11.2";

  src = fetchFromSavannah {
    repo = "guile-cairo";
    rev = "v${finalAttrs.version}";
    hash = "sha256-fPK5sMHnqmj/2BcY16uy7IUO/aSsWVwnSplZowCEdZA=";
  };

  nativeBuildInputs = [
    autoreconfHook
    guile
    pkg-config
    texinfo
  ];

  buildInputs = [
    cairo
    expat
    guile
  ];

  nativeCheckInputs = [ guile-lib ];

  doCheck = true; # Cannot find unit-test module from guile-lib

  enableParallelBuilding = true;

  strictDeps = true;

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
    maintainers = with lib.maintainers; [ vyp ];
    inherit (guile.meta) platforms;
  };
})

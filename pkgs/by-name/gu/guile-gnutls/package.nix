{
  lib,
  stdenv,
  fetchurl,
  buildPackages,
  gnutls,
  guile,
  libtool,
  pkg-config,
  texinfo,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "guile-gnutls";
  version = "5.0.2";

  src = fetchurl {
    url = "mirror://gnu/gnutls/guile-gnutls-${finalAttrs.version}.tar.gz";
    hash = "sha256-droqD0ft3n/S9YP8EWLtHOgzm9r36dnMOTh/zJX7k1s=";
  };

  strictDeps = true;

  depsBuildBuild = [
    buildPackages.stdenv.cc
  ];

  nativeBuildInputs = [
    gnutls
    guile
    libtool
    texinfo
    pkg-config
  ];

  buildInputs = [
    gnutls
    guile
  ];

  configureFlags = [
    "--with-guile-site-dir=${placeholder "out"}/${guile.siteDir}"
    "--with-guile-site-ccache-dir=${placeholder "out"}/${guile.siteCcacheDir}"
    "--with-guile-extension-dir=${placeholder "out"}/lib/guile/${guile.effectiveVersion}/extensions"
  ];

  meta = {
    homepage = "https://gitlab.com/gnutls/guile/";
    description = "Guile bindings for GnuTLS library";
    license = lib.licenses.lgpl21Plus;
    maintainers = [ ];
    platforms = guile.meta.platforms;
  };
})

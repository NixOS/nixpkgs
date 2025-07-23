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

stdenv.mkDerivation rec {
  pname = "guile-gnutls";
  version = "5.0.1";

  src = fetchurl {
    url = "mirror://gnu/gnutls/guile-gnutls-${version}.tar.gz";
    hash = "sha256-zABn8+60IbwXJHFAlipJCG31RQ8NPnHFW/VBotK57ys=";
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
    "--with-guile-site-dir=${builtins.placeholder "out"}/${guile.siteDir}"
    "--with-guile-site-ccache-dir=${builtins.placeholder "out"}/${guile.siteCcacheDir}"
    "--with-guile-extension-dir=${builtins.placeholder "out"}/lib/guile/${guile.effectiveVersion}/extensions"
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/gnutls/guile/";
    description = "Guile bindings for GnuTLS library";
    license = licenses.lgpl21Plus;
    maintainers = with maintainers; [ foo-dogsquared ];
    platforms = guile.meta.platforms;
  };
}

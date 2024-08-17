{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  autoconf,
  automake,
  texinfo,
  guile,
  glib,
  gobject-introspection,
  guile-lib,
  gtk3,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "g-golf";
  version = "0.8.0-rc.5";

  src = fetchurl {
    url = "http://ftp.gnu.org/gnu/g-golf/g-golf-${finalAttrs.version}.tar.gz";
    hash = "sha256-pF7ORAr1c56J+Sv9BIDlk0JrhWrfGsAc0OAfm3r3gVk=";
  };

  nativeBuildInputs = [
    pkg-config
    autoconf
    automake
    texinfo
  ];

  buildInputs = [
    guile
    glib
    gobject-introspection
  ];

  checkInputs = [
    guile-lib
    gtk3
  ];

  postPatch = ''
    substituteInPlace configure.ac \
        --replace 'SITEDIR="$datadir/g-golf"' \
            'SITEDIR="$prefix/${guile.siteDir}"' \
        --replace 'SITECCACHEDIR="$libdir/g-golf/guile/$GUILE_EFFECTIVE_VERSION/site-ccache"' \
            'SITECCACHEDIR="$prefix/${guile.siteCcacheDir}"'
  '';

  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  preBuild = ''
    export GUILE_EXTENSIONS_PATH="${
      lib.strings.makeLibraryPath [
        glib
        gobject-introspection
      ]
    }''${GUILE_EXTENSIONS_PATH:+:$GUILE_EXTENSIONS_PATH}"
  '';

  # TODO: Check fails.
  doCheck = false;

  installTargets = "install install-info";

  meta = {
    description = "Guile Object Library for GNOME";
    homepage = "https://www.gnu.org/software/g-golf/";
    changlog = "https://git.savannah.gnu.org/cgit/g-golf.git/tree/NEWS?h=v${finalAttrs.version}";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ rc-zb ];
    platforms = lib.platforms.unix;
  };
})

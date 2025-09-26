{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  automake117x,
  autoconf,
  libtool,
  gnumake,
  gcc,
  gnum4,
  gettext,
  texinfo,
  guile,
  guile-lib,
  gobject-introspection,
  glib,
  xvfb-run,
  gtk3,
  gtk4,
  which,
  libadwaita,
}:
stdenv.mkDerivation (finalAttrs: {

  pname = "g-golf";
  version = "0.8.2";

  src = fetchurl {
    url = "mirror://gnu/g-golf/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-eXO+RcHFckjPouX1rIhrlv712X0hLTx3s+uRnsLNHQM=";
  };

  doCheck = true;
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];

  nativeBuildInputs = [
    pkg-config
    automake117x
    autoconf
    libtool
    gnumake
    gcc
    gnum4
    gettext
    texinfo
    guile
    guile-lib
    xvfb-run
    gtk3
    glib
  ];

  buildInputs = [
    gobject-introspection
  ];

  postPatch = ''
    sed -i 's|libgirepository-1.0|${gobject-introspection}/lib/libgirepository-1.0.so|' g-golf/init.scm
    sed -i "s|libglib-2.0|${glib.out}/lib/libglib-2.0.so|" g-golf/init.scm
    sed -i "s|libgobject-2.0|${glib.out}/lib/libgobject-2.0.so|" g-golf/init.scm

    # In build environment, There is no /dev/tty
    sed -i "s|/dev/tty|/dev/null|g" test-suite/tests/gobject.scm

    sed -i "s|SITEDIR=.*$|SITEDIR="$out/${guile.siteDir}"|" configure.ac
    sed -i "s|SITECCACHEDIR=.*$|SITECCACHEDIR="$out/${guile.siteCcacheDir}"|" configure.ac
  '';

  checkPhase = ''
    runHook preCheck
    xvfb-run make check
    runHook postCheck
  '';

  postFixup = ''
    sed -i "s|(dynamic-link \"libg-golf\")|(dynamic-link \"$out/lib/libg-golf\")|" $out/${guile.siteDir}/g-golf/init.scm
  '';

  meta = {
    description = "Guile Object Library for GNOME";
    homepage = "https://www.gnu.org/software/g-golf/";
    license = lib.licenses.lgpl3Plus;
    maintainers = with lib.maintainers; [ mobid ];
    platforms = lib.platforms.unix;
  };
})

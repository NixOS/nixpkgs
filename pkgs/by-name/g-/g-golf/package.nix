{
  lib,
  stdenv,
  fetchurl,
  glib,
  gobject-introspection,
  gtk3,
  guile,
  guile-lib,
  pkg-config,
  texinfo,
  xvfb-run,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "g-golf";
  version = "0.8.2";

  src = fetchurl {
    url = "mirror://gnu/g-golf/g-golf-${finalAttrs.version}.tar.gz";
    sha256 = "sha256-eXO+RcHFckjPouX1rIhrlv712X0hLTx3s+uRnsLNHQM=";
  };

  strictDeps = true;

  propagatedNativeBuildInputs = [
    gobject-introspection
  ];
  nativeBuildInputs = [
    guile
    pkg-config
    texinfo # for makeinfo
  ];
  buildInputs = [
    guile
  ];
  postConfigure = ''
    substituteInPlace g-golf/init.scm \
      --replace-fail '"libgirepository-1.0"' '"${gobject-introspection}/lib/libgirepository-1.0.so"' \
      --replace-fail '"libglib-2.0"' '"${glib.out}/lib/libglib-2.0.so"' \
      --replace-fail '"libgobject-2.0"' '"${glib.out}/lib/libgobject-2.0.so"'
  '';
  postPatch = ''
    substituteInPlace configure \
      --replace-fail 'SITEDIR=' 'SITEDIR="${placeholder "out"}/${guile.siteDir}" #' \
      --replace-fail 'SITECCACHEDIR=' SITECCACHEDIR="${placeholder "out"}/${guile.siteCcacheDir}" #'
  '';
  makeFlags = [ "GUILE_AUTO_COMPILE=0" ];
  enableParallelBuilding = true;

  doCheck = true;
  nativeCheckInputs = [
    xvfb-run
  ];
  checkInputs = [
    gtk3
    guile-lib
  ];
  preCheck = ''
    # In build environment, there is no /dev/tty
    substituteInPlace test-suite/tests/gobject.scm \
      --replace-warn /dev/tty /dev/null
  '';
  checkFlags = [
    "GUILE_EXTENSIONS_PATH=$GUILE_EXTENSIONS_PATH:${gtk3.out}/lib"
  ];
  checkPhase = ''
    runHook preCheck
    xvfb-run make check
    runHook postCheck
  '';

  preFixup = ''
    substituteInPlace ${placeholder "out"}/${guile.siteDir}/g-golf/init.scm \
      --replace-fail '"libg-golf"' '"${placeholder "out"}/lib/libg-golf.so"'
  '';

  meta = with lib; {
    description = "GNOME object library for Guile";
    homepage = "https://www.gnu.org/software/g-golf";
    license = licenses.lgpl3Plus;
    maintainers = with maintainers; [ jboy ];
    platforms = platforms.linux;
  };
})

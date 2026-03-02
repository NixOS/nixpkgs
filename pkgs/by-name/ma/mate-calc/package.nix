{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  itstool,
  gtk3,
  libmpc,
  libxml2,
  mpfr,
  wrapGAppsHook3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-calc";
  version = "1.28.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-calc-${finalAttrs.version}.tar.xz";
    sha256 = "gEsSXR4oZLHnSvgW2psquLGUcrmvl0Q37nNVraXmKPU=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    gettext
    itstool
    libxml2 # xmllint
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    libmpc
    libxml2
    mpfr
  ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-calc";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Calculator for the MATE desktop";
    homepage = "https://mate-desktop.org";
    license = [ lib.licenses.gpl2Plus ];
    platforms = lib.platforms.linux;
    teams = [ lib.teams.mate ];
  };
})

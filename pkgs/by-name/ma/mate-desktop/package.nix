{
  lib,
  stdenv,
  fetchurl,
  pkg-config,
  gettext,
  isocodes,
  libstartup_notification,
  gtk3,
  dconf,
  wrapGAppsHook3,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-desktop";
  version = "1.28.2";

  outputs = [
    "out"
    "dev"
    "man"
  ];

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-desktop-${finalAttrs.version}.tar.xz";
    sha256 = "MrtLeSAUs5HB4biunBioK01EdlCYS0y6fSjpVWSWSqI=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    wrapGAppsHook3
  ];

  buildInputs = [
    dconf
    isocodes
  ];

  propagatedBuildInputs = [
    gtk3
    libstartup_notification
  ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mate-desktop";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "Library with common API for various MATE modules";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl2Plus;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.mate ];
  };
})

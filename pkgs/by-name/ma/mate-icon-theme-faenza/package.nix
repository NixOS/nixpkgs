{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  gtk3,
  mate-icon-theme,
  hicolor-icon-theme,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mate-icon-theme-faenza";
  version = "1.20.0";

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor finalAttrs.version}/mate-icon-theme-faenza-${finalAttrs.version}.tar.xz";
    sha256 = "000vr9cnbl2qlysf2gyg1lsjirqdzmwrnh6d3hyrsfc0r2vh4wna";
  };

  nativeBuildInputs = [
    autoreconfHook
    gtk3
  ];

  propagatedBuildInputs = [
    mate-icon-theme
    hicolor-icon-theme
  ];

  dontDropIconThemeCache = true;

  postInstall = ''
    for theme in "$out"/share/icons/*; do
      gtk-update-icon-cache "$theme"
    done
  '';

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://github.com/mate-desktop-legacy-archive/mate-icon-theme-faenza";
    rev-prefix = "v";
  };

  meta = {
    description = "Faenza icon theme from MATE";
    homepage = "https://mate-desktop.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
})

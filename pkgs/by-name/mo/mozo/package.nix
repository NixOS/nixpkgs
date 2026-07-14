{
  lib,
  python3,
  fetchurl,
  pkg-config,
  gettext,
  mate-menus,
  gtk3,
  glib,
  wrapGAppsHook3,
  gobject-introspection,
  gitUpdater,
}:

python3.pkgs.buildPythonApplication rec {
  pname = "mozo";
  version = "1.28.0";

  pyproject = false;
  doCheck = false;

  src = fetchurl {
    url = "https://pub.mate-desktop.org/releases/${lib.versions.majorMinor version}/mozo-${version}.tar.xz";
    sha256 = "/piYT/1qqMNtBZS879ugPeObQtQeAHJRaAOE8870SSQ=";
  };

  nativeBuildInputs = [
    pkg-config
    gettext
    gobject-introspection
    wrapGAppsHook3
  ];

  propagatedBuildInputs = [
    mate-menus
    python3.pkgs.pygobject3
  ];

  buildInputs = [
    gtk3
    glib
  ];

  enableParallelBuilding = true;

  passthru.updateScript = gitUpdater {
    url = "https://git.mate-desktop.org/mozo";
    odd-unstable = true;
    rev-prefix = "v";
  };

  meta = {
    description = "MATE Desktop menu editor";
    mainProgram = "mozo";
    homepage = "https://github.com/mate-desktop/mozo";
    license = with lib.licenses; [ lgpl2Plus ];
    platforms = lib.platforms.unix;
    teams = [ lib.teams.mate ];
  };
}

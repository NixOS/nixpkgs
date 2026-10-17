{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  itstool,
  gettext,
  desktop-file-utils,
  wrapGAppsHook4,
  libxml2,
  libadwaita,
  libsoup_3,
  libspelling,
  json-glib,
  glib,
  gtk4,
  gtksourceview5,
  gnome,
  gsettings-desktop-schemas,
  sqlite,
}:

stdenv.mkDerivation rec {
  pname = "gtranslator";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gtranslator/${lib.versions.major version}/gtranslator-${version}.tar.xz";
    hash = "sha256-hXtRx49U30JBj/b6nmK4VU338CHLEjOMH8DYW5nJGO8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    itstool
    gettext
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    libxml2
    glib
    gtk4
    gtksourceview5
    libadwaita
    libsoup_3
    libspelling
    json-glib
    gettext
    gsettings-desktop-schemas
    sqlite
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = pname;
    };
  };

  meta = {
    description = "GNOME translation making program";
    mainProgram = "gtranslator";
    homepage = "https://gitlab.gnome.org/GNOME/gtranslator";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ bobby285271 ];
    platforms = lib.platforms.linux;
  };
}

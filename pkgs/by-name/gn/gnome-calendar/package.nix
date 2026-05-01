{
  stdenv,
  lib,
  fetchurl,
  blueprint-compiler,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  libgweather,
  geoclue2,
  gettext,
  libxml2,
  gnome,
  gtk4,
  evolution-data-server-gtk4,
  libical,
  libsoup_3,
  glib,
  glib-networking,
  gsettings-desktop-schemas,
  libadwaita,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-calendar";
  version = "49.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calendar/${lib.versions.major finalAttrs.version}/gnome-calendar-${finalAttrs.version}.tar.xz";
    hash = "sha256-DBEVqylNUyxMGfVs4Neu5T+OoysUMCCd0dntpHqD0sI=";
  };

  nativeBuildInputs = [
    blueprint-compiler
    meson
    ninja
    pkg-config
    gettext
    libxml2
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    evolution-data-server-gtk4
    libical
    libsoup_3
    glib
    glib-networking
    libgweather
    geoclue2
    gsettings-desktop-schemas
    libadwaita
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-calendar";
    };
  };

  meta = {
    homepage = "https://apps.gnome.org/Calendar/";
    description = "Simple and beautiful calendar application for GNOME";
    mainProgram = "gnome-calendar";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.unix;
  };
})

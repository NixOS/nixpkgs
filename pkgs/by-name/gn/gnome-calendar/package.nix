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
  gsettings-desktop-schemas,
  libadwaita,
}:

stdenv.mkDerivation rec {
  pname = "gnome-calendar";
  version = "49.0.1";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calendar/${lib.versions.major version}/gnome-calendar-${version}.tar.xz";
    hash = "sha256-4L/k6hCUItraB0Xdj4wOAjCriCB3ENHAfiRTIs+RP/I=";
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

  meta = with lib; {
    homepage = "https://apps.gnome.org/Calendar/";
    description = "Simple and beautiful calendar application for GNOME";
    mainProgram = "gnome-calendar";
    teams = [ teams.gnome ];
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

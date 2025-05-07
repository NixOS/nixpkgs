{
  stdenv,
  lib,
  fetchurl,
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
  version = "48.rc";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-calendar/${lib.versions.major version}/gnome-calendar-${version}.tar.xz";
    hash = "sha256-kCo4kVm8M6SKBE250y4kJWj2vigGvMiBMixF9+02A+4=";
  };

  nativeBuildInputs = [
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

{
  stdenv,
  lib,
  fetchurl,
  pkg-config,
  gnome,
  gtk4,
  wrapGAppsHook4,
  libadwaita,
  librsvg,
  gettext,
  itstool,
  libxml2,
  meson,
  ninja,
  glib,
  vala,
  desktop-file-utils,
}:

stdenv.mkDerivation rec {
  pname = "gnome-mahjongg";
  version = "47.0";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mahjongg/${lib.versions.major version}/gnome-mahjongg-${version}.tar.xz";
    hash = "sha256-WPFX8Lxexxq42jXc5+c8ougZLFsvIZFnqSaTC5cdpJs=";
  };

  nativeBuildInputs = [
    meson
    ninja
    vala
    desktop-file-utils
    pkg-config
    libxml2
    itstool
    gettext
    wrapGAppsHook4
    glib # for glib-compile-schemas
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    librsvg
  ];

  passthru = {
    updateScript = gnome.updateScript { packageName = "gnome-mahjongg"; };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-mahjongg";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-mahjongg/-/blob/${version}/NEWS?ref_type=tags";
    description = "Disassemble a pile of tiles by removing matching pairs";
    mainProgram = "gnome-mahjongg";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
}

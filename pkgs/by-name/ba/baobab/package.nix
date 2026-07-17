{
  stdenv,
  lib,
  gettext,
  fetchurl,
  vala,
  desktop-file-utils,
  meson,
  ninja,
  pkg-config,
  gtk4,
  libadwaita,
  glib,
  libxml2,
  wrapGAppsHook4,
  itstool,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "baobab";
  version = "50.0";

  src = fetchurl {
    url = "mirror://gnome/sources/baobab/${lib.versions.major finalAttrs.version}/baobab-${finalAttrs.version}.tar.xz";
    hash = "sha256-VzyE8V9fljpEBQD29DQSySisIzX2tp3LWPGh/lIBAks=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glib
    itstool
    libxml2
    meson
    ninja
    pkg-config
    vala
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    glib
  ];

  doCheck = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "baobab";
    };
  };

  meta = {
    description = "Graphical application to analyse disk usage in any GNOME environment";
    mainProgram = "baobab";
    homepage = "https://apps.gnome.org/Baobab/";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
  };
})

{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  gnome,
  gtk4,
  wrapGAppsHook4,
  glib,
  gobject-introspection,
  gi-docgen,
  libadwaita,
  libdex,
  gom,
  flatpak,
  libfoundry,
  libpanel,
  webkitgtk_6_0,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-manuals";
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/manuals/${lib.versions.major finalAttrs.version}/manuals-${finalAttrs.version}.tar.xz";
    hash = "sha256-7WRGxMLSnCuQYrKoynJxzbrPx4z9tP3NDzvEjYyefwg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libdex
    gom
    flatpak
    libfoundry
    libpanel
    webkitgtk_6_0
  ];

  strictDeps = true;

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "manuals";
    };
  };

  meta = {
    description = "Tool for browsing documentation";
    mainProgram = "manuals";
    homepage = "https://apps.gnome.org/Manuals/";
    changelog = "https://gitlab.gnome.org/GNOME/manuals/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})

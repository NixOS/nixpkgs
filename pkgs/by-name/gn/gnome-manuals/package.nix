{
  stdenv,
  lib,
  desktop-file-utils,
  fetchurl,
  flatpak,
  glib,
  gnome,
  gom,
  gtk4,
  libadwaita,
  libdex,
  libfoundry,
  libpanel,
  meson,
  ninja,
  pkg-config,
  webkitgtk_6_0,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-manuals";
  version = "50.1";

  src = fetchurl {
    url = "mirror://gnome/sources/manuals/${lib.versions.major finalAttrs.version}/manuals-${finalAttrs.version}.tar.xz";
    hash = "sha256-foRBdV0N5xdCjIAORa4GyF7JZK9GrFO53GW0G8OjLHQ=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    flatpak
    glib
    gom
    gtk4
    libadwaita
    libdex
    libfoundry
    libpanel
    webkitgtk_6_0
  ];

  strictDeps = true;

  preFixup = ''
    gappsWrapperArgs+=(--prefix XDG_DATA_DIRS : "${libpanel}/share")
  '';

  passthru.updateScript = gnome.updateScript {
    packageName = "manuals";
    attrPath = "gnome-manuals";
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

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
  flatpak,
  libfoundry,
  webkitgtk_6_0,
  gettext,
  itstool,
  # gsettings-desktop-schemas,
  shared-mime-info,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-manuals";
  version = "49.0";

  outputs = [
    "out"
    # "devdoc"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/manuals/${lib.versions.major finalAttrs.version}/manuals-${finalAttrs.version}.tar.xz";
    hash = "sha256-7WRGxMLSnCuQYrKoynJxzbrPx4z9tP3NDzvEjYyefwg=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    # gettext
    # itstool
    wrapGAppsHook4
    # gobject-introspection
    # gi-docgen
    # post install script
    # glib
    # gtk4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libdex
    flatpak
    libfoundry
    webkitgtk_6_0
    # gsettings-desktop-schemas
  ];

  strictDeps = true;

  # mesonFlags = [
  #   "-Dgtk_doc=true"
  # ];

  # doCheck = true;

  # preFixup = ''
  #   gappsWrapperArgs+=(
  #     # Fix pages being blank
  #     # https://gitlab.gnome.org/GNOME/manuals/issues/14
  #     --prefix XDG_DATA_DIRS : "${shared-mime-info}/share"
  #   )
  # '';

  # postFixup = ''
  #   # Cannot be in postInstall, otherwise _multioutDocs hook in preFixup will move right back.
  #   moveToOutput share/doc/manuals-3 "$devdoc"
  # '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "manuals";
    };
  };

  meta = {
    description = "API documentation browser for GNOME";
    mainProgram = "manuals";
    homepage = "https://apps.gnome.org/Manuals/";
    changelog = "https://gitlab.gnome.org/GNOME/manuals/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    license = lib.licenses.gpl3Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.linux;
  };
})

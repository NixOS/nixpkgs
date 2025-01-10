{
  lib,
  stdenv,
  meson,
  fetchurl,
  python3,
  pkg-config,
  gtk4,
  glib,
  gtksourceview5,
  gsettings-desktop-schemas,
  wrapGAppsHook4,
  ninja,
  gnome,
  cairo,
  icu,
  itstool,
  libadwaita,
  libspelling,
  editorconfig-core-c,
  libxml2,
  desktop-file-utils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-text-editor";
  version = "47.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-text-editor/${lib.versions.major finalAttrs.version}/gnome-text-editor-${finalAttrs.version}.tar.xz";
    hash = "sha256-fQQDmxYXTsX9Zf6i9Efz/r2f3yqjbpmXq8b/mSzDHjg=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    itstool
    libxml2 # for xmllint
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    cairo
    icu
    glib
    gsettings-desktop-schemas
    gtk4
    gtksourceview5
    libadwaita
    libspelling
    editorconfig-core-c
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "gnome-text-editor";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-text-editor";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-text-editor/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Text Editor for GNOME";
    mainProgram = "gnome-text-editor";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
})

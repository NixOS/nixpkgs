{ lib
, stdenv
, fetchurl
, desktop-file-utils
, gettext
, glibcLocales
, itstool
, libxml2
, meson
, ninja
, pkg-config
, python3
, wrapGAppsHook4
, cpio
, glib
, gnome
, gtk4
, libadwaita
, json-glib
, libarchive
, nautilus
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "file-roller";
  version = "44.4";

  src = fetchurl {
    url = "mirror://gnome/sources/file-roller/${lib.versions.major finalAttrs.version}/file-roller-${finalAttrs.version}.tar.xz";
    hash = "sha256-uMMJ2jqnhMcZVYw0ZkAjePSj1sro7XfPaEmqzVbOuew=";
  };

  nativeBuildInputs = [
    desktop-file-utils
    gettext
    glibcLocales
    itstool
    libxml2
    meson
    ninja
    pkg-config
    python3
    wrapGAppsHook4
  ];

  buildInputs = [
    cpio
    glib
    gtk4
    libadwaita
    json-glib
    libarchive
    nautilus
  ];

  postPatch = ''
    patchShebangs data/set-mime-type-entry.py
  '';

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "file-roller";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/file-roller";
    changelog = "https://gitlab.gnome.org/GNOME/file-roller/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Archive manager for the GNOME desktop environment";
    license = licenses.gpl2Plus;
    platforms = platforms.linux;
    maintainers = teams.gnome.members ++ teams.pantheon.members;
    mainProgram = "file-roller";
  };
})

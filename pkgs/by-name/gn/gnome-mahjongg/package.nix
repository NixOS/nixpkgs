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

stdenv.mkDerivation (finalAttrs: {
  pname = "gnome-mahjongg";
  version = "47.2";

  src = fetchurl {
    url = "mirror://gnome/sources/gnome-mahjongg/${lib.versions.major finalAttrs.version}/gnome-mahjongg-${finalAttrs.version}.tar.xz";
    hash = "sha256-Nd+SZBnzeCY4CjNGIHVjzYfH6ZoT3r4Ok6FAnYXMYVc=";
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
    updateScript = gnome.updateScript {
      packageName = "gnome-mahjongg";
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gnome-mahjongg";
    changelog = "https://gitlab.gnome.org/GNOME/gnome-mahjongg/-/blob/${finalAttrs.version}/NEWS?ref_type=tags";
    description = "Disassemble a pile of tiles by removing matching pairs";
    mainProgram = "gnome-mahjongg";
    maintainers = teams.gnome.members;
    license = licenses.gpl3Plus;
    platforms = platforms.unix;
  };
})

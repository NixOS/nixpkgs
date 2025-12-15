{
  stdenv,
  lib,
  fetchurl,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  glib,
  gtk4,
  libadwaita,
  libxkbcommon,
  wayland,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "tecla";
  version = "49.0";

  src = fetchurl {
    url = "mirror://gnome/sources/tecla/${lib.versions.major finalAttrs.version}/tecla-${finalAttrs.version}.tar.xz";
    hash = "sha256-LKQk5AK69gzWsTd3cDtwHrsfr489Dy+XEUTYI/ZRJJ8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libxkbcommon
    wayland
  ];

  passthru = {
    updateScript = gnome.updateScript {
      attrPath = "gnome-tecla";
      packageName = "tecla";
    };
  };

  meta = {
    description = "Keyboard layout viewer";
    homepage = "https://gitlab.gnome.org/GNOME/tecla";
    license = lib.licenses.gpl2Plus;
    teams = [ lib.teams.gnome ];
    platforms = lib.platforms.unix;
    mainProgram = "tecla";
  };
})

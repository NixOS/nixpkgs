{
  stdenv,
  lib,
  desktop-file-utils,
  fetchurl,
  glib,
  gettext,
  gtk4,
  libadwaita,
  libdex,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gnome,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "d-spy";
  version = "49.2";

  outputs = [
    "out"
    "dev"
  ];

  src = fetchurl {
    url = "mirror://gnome/sources/d-spy/${lib.versions.major finalAttrs.version}/d-spy-${finalAttrs.version}.tar.xz";
    hash = "sha256-uBT/J9goqrzacvLGLxtB1iA190PQb9mn48XJhsSHmmk=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    desktop-file-utils
    wrapGAppsHook4
    gettext
    glib
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    libdex
  ];

  passthru = {
    updateScript = gnome.updateScript {
      packageName = "d-spy";
    };
  };

  meta = with lib; {
    description = "D-Bus exploration tool";
    mainProgram = "d-spy";
    homepage = "https://gitlab.gnome.org/GNOME/d-spy";
    license = licenses.gpl3Plus;
    teams = [ teams.gnome ];
    platforms = platforms.linux;
  };
})

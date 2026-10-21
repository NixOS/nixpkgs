{
  lib,
  stdenv,
  fetchFromGitLab,
  appstream-glib,
  desktop-file-utils,
  glib,
  gtk4,
  gtksourceview5,
  libadwaita,
  libpanel,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "schemes";
  version = "46.0";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "chergert";
    repo = "schemes";
    rev = finalAttrs.version;
    hash = "sha256-m82jR958f1g/4gSJ4NbNa4fwxVseH399Z8JpWr7tLh8=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream-glib
    desktop-file-utils
  ];

  buildInputs = [
    glib
    gtk4
    libadwaita
    gtksourceview5
    libpanel
  ];

  meta = {
    description = "Edit GtkSourceView style-schemes for an application or platform";
    mainProgram = "schemes";
    homepage = "https://gitlab.gnome.org/chergert/schemes";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ _0xMRTT ];
    platforms = lib.platforms.linux;
  };
})

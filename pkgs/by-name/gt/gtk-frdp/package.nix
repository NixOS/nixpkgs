{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  vala,
  gobject-introspection,
  glib,
  gtk3,
  freerdp,
  fuse3,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "gtk-frdp";
  version = "0-unstable-2026-02-24";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gtk-frdp";
    rev = "5351db944c9df7bac071be8dc7398aed23fc57ca";
    hash = "sha256-wcjdV9+kJD7kpZVcWxTImK+xex0SIlydsrfX6mr+asE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    vala
    gobject-introspection
  ];

  buildInputs = [
    glib
    gtk3
    freerdp
    fuse3
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
      hardcodeZeroVersion = true;
    };
  };

  meta = {
    homepage = "https://gitlab.gnome.org/GNOME/gtk-frdp";
    description = "RDP viewer widget for GTK";
    teams = [ lib.teams.gnome ];
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.unix;
  };
}

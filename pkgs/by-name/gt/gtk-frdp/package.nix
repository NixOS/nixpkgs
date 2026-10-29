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
  version = "0-unstable-2026-07-24";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gtk-frdp";
    rev = "83854a24e31d1c07519f6e4393fe280d3b59e080";
    hash = "sha256-6f0irRBkpmOYrhXkeSR6ni55SJiltOfYRiwZy5V/VrE=";
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
    platforms = lib.platforms.linux;
  };
}

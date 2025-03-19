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
  freerdp3,
  fuse3,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "gtk-frdp";
  version = "0-unstable-2024-12-23";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gtk-frdp";
    rev = "46ca0beb9b5bf8c9b245a596231016bcca9baf6b";
    sha256 = "zRC3YVe2WwOmVzEDaJwsct3YQ4ZbvYTr2CTyRmfCXFY=";
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
    freerdp3
    fuse3
  ];

  passthru = {
    updateScript = unstableGitUpdater {
      tagPrefix = "v";
      hardcodeZeroVersion = true;
    };
  };

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gtk-frdp";
    description = "RDP viewer widget for GTK";
    maintainers = teams.gnome.members;
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
}

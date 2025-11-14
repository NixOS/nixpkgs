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
  version = "0-unstable-2025-08-15";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "GNOME";
    repo = "gtk-frdp";
    rev = "b59dc88624511311576dca607d3cb9317569de34";
    hash = "sha256-6zCaegBshOLQWeHtUYOaofbUVK797vyn5bdpwHD0Z/s=";
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

  meta = with lib; {
    homepage = "https://gitlab.gnome.org/GNOME/gtk-frdp";
    description = "RDP viewer widget for GTK";
    teams = [ teams.gnome ];
    license = licenses.lgpl3Plus;
    platforms = platforms.unix;
  };
}

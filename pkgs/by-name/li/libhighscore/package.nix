{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  glib,
  vala,
  gobject-introspection,
  unstableGitUpdater,
}:

stdenv.mkDerivation {
  pname = "libhighscore";
  version = "0-unstable-2026-01-28";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "alicem";
    repo = "libhighscore";
    rev = "b22ff493501ba3b69529feadb91767a6a3dba050";
    hash = "sha256-4Ozy0kAzC+VpC+wlIVyvvOYYON7E/GZFw9uNXpq3O5I=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    glib # For glib-mkenums
    gobject-introspection # For g-ir-scanner
    vala # For vapigen
  ];

  # In highscore-1.pc
  propagatedBuildInputs = [
    glib
  ];

  passthru.updateScript = unstableGitUpdater {
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Interface for porting emulators to Highscore";
    homepage = "https://gitlab.gnome.org/alicem/libhighscore";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [
      chuangzhu
      aleksana
    ];
    platforms = lib.platforms.linux;
  };
}

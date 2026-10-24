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
  version = "0-unstable-2026-10-09";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "alicem";
    repo = "libhighscore";
    rev = "426df57dfd8bb65c93fe2a8fddf453999ef47174";
    hash = "sha256-OmoXQjUKYRem1CDzAYUekit9U5xPSdrQkP/FPOxnTf4=";
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

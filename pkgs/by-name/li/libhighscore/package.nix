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
  version = "0-unstable-2026-08-24";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "alicem";
    repo = "libhighscore";
    rev = "e8e49360f93c65dc0d492feeb0f8a869f4733832";
    hash = "sha256-8VLY2WiJPzYXMMMhw11QP/Knn2d37d96PZaN00dwYXU=";
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

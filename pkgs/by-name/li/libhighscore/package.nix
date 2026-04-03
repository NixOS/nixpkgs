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
  version = "0-unstable-2026-01-30";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "alicem";
    repo = "libhighscore";
    rev = "81366c670b777a6943dbdd955b9e867c8da247e7";
    hash = "sha256-z+gMU9IA0F9alrhXNf5e+0/J87ChwVyCn26iA+ythBE=";
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

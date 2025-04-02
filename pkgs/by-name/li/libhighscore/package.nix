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

stdenv.mkDerivation (finalAttrs: {
  pname = "libhighscore";
  version = "0-unstable-2024-11-18";

  src = fetchFromGitLab {
    domain = "gitlab.gnome.org";
    owner = "alicem";
    repo = "libhighscore";
    rev = "0b019bb0cfa24e25c29ca5edd58d401170a23eda";
    hash = "sha256-x8+chbFbASevLwTEFEBfOAwKOwmb3hCyO5nnq6Phu+8=";
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
    url = finalAttrs.src.gitRepoUrl;
    hardcodeZeroVersion = true;
  };

  meta = {
    description = "Interface for porting emulators to Highscore";
    homepage = "https://gitlab.gnome.org/alicem/libhighscore";
    license = lib.licenses.lgpl21Plus;
    maintainers = with lib.maintainers; [ chuangzhu ];
  };
})

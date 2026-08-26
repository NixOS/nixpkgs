{
  lib,
  stdenv,
  fetchFromGitHub,
  appstream-glib,
  desktop-file-utils,
  libadwaita,
  meson,
  ninja,
  pkg-config,
  wrapGAppsHook4,
  gtk4,
  python3,
  gettext,
  cmake,
  gobject-introspection,
  unstableGitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "collector";
  version = "0-unstable-2026-04-17";

  src = fetchFromGitHub {
    owner = "mijorus";
    repo = "collector";
    rev = "c40da4053d0274cfc3d99d0a1a3ad0935a664a34";
    hash = "sha256-qAOcVGy9ExeitllGOZTqHQ1QnPK+2u4tPmhnwXUqHH0=";
  };

  nativeBuildInputs = [
    meson
    pkg-config
    ninja
    gettext
    cmake
    desktop-file-utils
    appstream-glib
    wrapGAppsHook4
  ];

  buildInputs = [
    gtk4
    libadwaita
    gobject-introspection
    (python3.withPackages (
      ps: with ps; [
        pillow
        requests
        pygobject3
      ]
    ))
  ];

  passthru.updateScript = unstableGitUpdater { hardcodeZeroVersion = true; };

  meta = {
    description = "Drag multiple files and folders on to Collection window, drop them anywhere";
    mainProgram = "collector";
    homepage = "https://github.com/mijorus/collector";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ CaptainJawZ ];
  };
})

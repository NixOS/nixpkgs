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
  version = "1.0.1";

  src = fetchFromGitHub {
    owner = "mijorus";
    repo = "collector";
    rev = "d98a11c65c7de054cb894aeb4b5e963aeb83c0d8";
    hash = "sha256-un+PvLAHfosX9jWExepWDbDKev7D9TAu+XfOFm7xOyA=";
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
    description = "Drag multiple files and folders on to Collection window, drop them anywhere!";
    mainProgram = "collector";
    homepage = "https://github.com/mijorus/collector";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ CaptainJawZ ];
  };
})

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
  version = "0-unstable-2024-08-02";

  src = fetchFromGitHub {
    owner = "mijorus";
    repo = "collector";
    rev = "7c83ef15ec6189005e63a036f00699adf1cb7132";
    hash = "sha256-WTNisQuwtyjZ73cVPhuCQkf7FkpAvNx3BrxjpzKc1/s=";
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

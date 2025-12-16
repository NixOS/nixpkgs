{
  lib,
  gcc15Stdenv,
  fetchFromGitHub,
  gtk3,
  jansson,
  luajit,
  meson,
  ninja,
  pkg-config,
  unstableGitUpdater,
  wrapGAppsHook3,
}:

gcc15Stdenv.mkDerivation {
  pname = "libresplit";
  version = "0-unstable-2025-12-08";

  src = fetchFromGitHub {
    owner = "LibreSplit";
    repo = "LibreSplit";
    rev = "38263d7f33cc2b26261f354090102deeeeb6f268";
    hash = "sha256-33j5+6IBbEjXW17ZpbkYkLTO0411iZDGXLAK/5SKa+4=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    wrapGAppsHook3
  ];

  buildInputs = [
    gtk3
    jansson
    luajit
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/LibreSplitDev/LibreSplit";
    description = "Speedrun timer with auto splitting and load removal for Linux";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "libresplit";
    platforms = lib.platforms.linux;
  };
}

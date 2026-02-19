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
  version = "0-unstable-2026-01-22";

  src = fetchFromGitHub {
    owner = "LibreSplit";
    repo = "LibreSplit";
    rev = "be1ae0ea476846bb7e296613f471ba8803b1d7ff";
    hash = "sha256-9BzzpKun8c9TFzwHHbGxFK6ThfVHRMUUqjwRiS+Lfks=";
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

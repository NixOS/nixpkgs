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
  version = "0-unstable-2025-12-12";

  src = fetchFromGitHub {
    owner = "LibreSplit";
    repo = "LibreSplit";
    rev = "0d1e3f5feab571cccf761b1c1391ee7f50b5f101";
    hash = "sha256-7XmvwYlqqn/IxR0eCLhkfrsY4omjICe6S2LCn55Sqgk=";
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

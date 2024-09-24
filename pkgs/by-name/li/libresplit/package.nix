{
  lib,
  stdenv,
  fetchFromGitHub,
  gtk3,
  jansson,
  luajit,
  pkg-config,
  unstableGitUpdater,
  wrapGAppsHook3,
  xxd,
}:

stdenv.mkDerivation {
  pname = "libresplit";
  version = "0-unstable-2024-06-05";

  src = fetchFromGitHub {
    owner = "wins1ey";
    repo = "LibreSplit";
    rev = "ba10e054e2cd3a96034e3a8d5758f4ad32759ff0";
    hash = "sha256-imKzBXwyJQeChT36FuY7ihZw+IcGbjp7LoMGRy3hM/0=";
  };

  nativeBuildInputs = [
    pkg-config
    wrapGAppsHook3
    xxd
  ];

  buildInputs = [
    gtk3
    jansson
    luajit
  ];

  makeFlags = [ "PREFIX=$(out)" ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    homepage = "https://github.com/wins1ey/LibreSplit";
    description = "Speedrun timer with auto splitting and load removal for Linux";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ fgaz ];
    mainProgram = "libresplit";
    platforms = lib.platforms.linux;
  };
}

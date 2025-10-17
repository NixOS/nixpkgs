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
  version = "0-unstable-2025-10-02";

  src = fetchFromGitHub {
    owner = "wins1ey";
    repo = "LibreSplit";
    rev = "0cb1b5d3eff0245fda17f734388eee609b9a4416";
    hash = "sha256-3DK+6pK0jSxy5s80u4lweMyiywknJPEG4rovhOPG4go=";
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

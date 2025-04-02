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
  version = "0-unstable-2025-03-04";

  src = fetchFromGitHub {
    owner = "wins1ey";
    repo = "LibreSplit";
    rev = "7077cad5affc335aabfd9497b5b361ade298b099";
    hash = "sha256-DIgYNc/idFeFHbpW73S0+mdc+S3UZJmgyelzogDIjDE=";
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

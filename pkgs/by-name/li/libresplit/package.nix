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
  version = "0-unstable-2025-09-22";

  src = fetchFromGitHub {
    owner = "wins1ey";
    repo = "LibreSplit";
    rev = "e1ff26fafd3b791a6dfd04538114d07c627251fa";
    hash = "sha256-3DTRDgIMu2JJg8AgbdsRvILKRaH024YDPdhMncjoM6I=";
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

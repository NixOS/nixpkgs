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
  version = "0-unstable-2025-06-15";

  src = fetchFromGitHub {
    owner = "wins1ey";
    repo = "LibreSplit";
    rev = "3ea7dc995249d38f99519b79159e6be403aa8e31";
    hash = "sha256-d4tlWk7b2n8OZ7rplgqMPf5cat3vq/8ChBRB0UdJ3ps=";
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

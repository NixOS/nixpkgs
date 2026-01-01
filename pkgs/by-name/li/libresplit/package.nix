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
<<<<<<< HEAD
  version = "0-unstable-2025-12-26";
=======
  version = "0-unstable-2025-11-15";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "LibreSplit";
    repo = "LibreSplit";
<<<<<<< HEAD
    rev = "11fcc57ff3ebbf58b3bb91b69575afbe4a8409b1";
    hash = "sha256-b743CPRpBZI5H+jFRn1O/s0LZzp8B5QWhjZ2N3iSz+g=";
=======
    rev = "68cecf6a0784bdf697bc65f490f3ebd701bcd989";
    hash = "sha256-T6g/8D/kgarlmstekFgY2Qt4OFpLivQtkU856jxAZ/Q=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)
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

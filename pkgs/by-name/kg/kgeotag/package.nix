{
  stdenv,
  cmake,
  fetchFromGitLab,
  lib,
  kdePackages,
  qt6,
}:

stdenv.mkDerivation {
  pname = "kgeotag";
  version = "1.8.0-unstable-2025-07-25";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "kgeotag";
    owner = "graphics";
    rev = "b2b140e8f72ab37bad3729bea527203324d12131";
    hash = "sha256-jUcKm4IPQt2JiZUmIjMJ9EG0kDjzoPGjzBPMHZ6j9lM=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.libkexiv2
    kdePackages.marble
    qt6.qtwebengine
  ];

  meta = with lib; {
    homepage = "https://kgeotag.kde.org/";
    description = "Stand-alone photo geotagging program";
    changelog = "https://invent.kde.org/graphics/kgeotag/-/blob/master/CHANGELOG.rst";
    license = licenses.gpl3Plus;
    maintainers = with maintainers; [ cimm ];
    mainProgram = "kgeotag";
  };
}

{
  stdenv,
  cmake,
  extra-cmake-modules,
  fetchFromGitLab,
  lib,
  libsForQt5,
}:

stdenv.mkDerivation rec {
  pname = "kgeotag";
  version = "1.6.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "kgeotag";
    owner = "graphics";
    rev = "v${version}";
    hash = "sha256-lUfU6SHRCglC81BTcVFFOp/psWXsUFOTEPUrZutrJaY=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.libkexiv2
    libsForQt5.marble
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

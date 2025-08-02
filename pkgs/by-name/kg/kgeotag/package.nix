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
  version = "1.7.0";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "kgeotag";
    owner = "graphics";
    rev = "v${version}";
    hash = "sha256-/NYAR/18Dh+fphCBz/zFWj/xqEl28e77ZtV8LlcGyMI=";
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

  meta = {
    homepage = "https://kgeotag.kde.org/";
    description = "Stand-alone photo geotagging program";
    changelog = "https://invent.kde.org/graphics/kgeotag/-/blob/master/CHANGELOG.rst";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ cimm ];
    mainProgram = "kgeotag";
  };
}

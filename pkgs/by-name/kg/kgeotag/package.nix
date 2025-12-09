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
  version = "1.8.0-unstable-2025-11-01";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "kgeotag";
    owner = "graphics";
    rev = "879418eb57e96beb5be3e3a69d0bab2b666b7c7f";
    hash = "sha256-RFC8UMrURn2vsTRjPFyLNlsep/PWRadkRkS7aFtTlKE=";
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

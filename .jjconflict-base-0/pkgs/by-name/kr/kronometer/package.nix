{
  fetchFromGitLab,
  stdenv,
  lib,
  cmake,
  kdePackages,
  qt6,
}:

stdenv.mkDerivation {
  pname = "kronometer";
  version = "2.3.0-unstable-2026-04-06";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "utilities";
    repo = "kronometer";
    rev = "ca1e662f4e58540bd072982103204fa1418f5657";
    hash = "sha256-IhKlFGxUqr7wKcNKnRA6gK9QJeR0QyQaSwYlIsr0wyE=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.kdoctools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kconfig
    kdePackages.kcrash
    kdePackages.kwidgetsaddons
    kdePackages.kxmlgui
  ];

  meta = {
    homepage = "https://kde.org/applications/utilities/kronometer/";
    description = "Stopwatch application";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    mainProgram = "kronometer";
  };
}

{
  lib,
  stdenv,
  fetchFromGitLab,
  qt6,
  kdePackages,
  cmake,
  shared-mime-info,
  gitUpdater,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "calligraplan";
  version = "4.0.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "office";
    repo = "calligraplan";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OD719omgw+RZrFz6qWiFDFB4t6Lvvh2M2QXYAIh0H2I=";
  };

  buildInputs = [
    qt6.qtbase
    kdePackages.karchive
    kdePackages.kcalendarcore
    kdePackages.kconfig
    kdePackages.kconfigwidgets
    kdePackages.kcoreaddons
    kdePackages.kdbusaddons
    kdePackages.kdiagram
    kdePackages.kguiaddons
    kdePackages.kholidays
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kio
    kdePackages.kitemmodels
    kdePackages.kitemviews
    kdePackages.kjobwidgets
    kdePackages.knotifications
    kdePackages.kparts
    kdePackages.ktextwidgets
    kdePackages.kwidgetsaddons
    kdePackages.kwindowsystem
    kdePackages.kxmlgui
    kdePackages.plasma-activities
    kdePackages.sonnet
  ];

  nativeBuildInputs = [
    qt6.wrapQtAppsHook
    cmake
    kdePackages.extra-cmake-modules
    shared-mime-info
  ];

  passthru = {
    updateScript = gitUpdater { rev-prefix = "v"; };
  };

  meta = {
    homepage = "https://www.calligra.org/plan/";
    license = lib.licenses.gpl2Only;
    platforms = lib.platforms.unix;
    maintainers = with lib.maintainers; [ bot-wxt1221 ];
    description = "Project Management Application";
    mainProgram = "calligraplan";
    changelog = "https://invent.kde.org/office/calligraplan/-/tags/v${finalAttrs.version}";
  };
})

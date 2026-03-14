{
  lib,
  stdenv,
  fetchFromGitLab,
  fetchpatch,
  qt5,
  libsForQt5,
  cmake,
  extra-cmake-modules,
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
    qt5.qtbase
    libsForQt5.kdbusaddons
    libsForQt5.kguiaddons
    libsForQt5.ki18n
    libsForQt5.kiconthemes
    libsForQt5.kitemviews
    libsForQt5.kjobwidgets
    libsForQt5.kio
    libsForQt5.knotifications
    libsForQt5.kparts
    libsForQt5.kinit
    libsForQt5.kdiagram
    libsForQt5.qt5.qtx11extras
  ];

  nativeBuildInputs = [
    qt5.wrapQtAppsHook
    cmake
    extra-cmake-modules
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

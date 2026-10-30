{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  ninja,
  pkg-config,
  kdePackages,
  libghostty-vt,
  testers,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kwi";
  version = "0.1.0-unstable-2026-10-30";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "utilities";
    repo = "kwi";
    rev = "e023240d202cd43004f52b2b0b8efcd979e62d80";
    hash = "sha256-XtlAzjFKUYh0ha3c9kqq5LYbN7XzAI8shmkbd+2VmoA=";
  };

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    libghostty-vt

    # Qt 6
    kdePackages.qtbase
    kdePackages.qtdeclarative
    kdePackages.qtshadertools
    kdePackages.qtsvg

    # KDE Frameworks 6
    kdePackages.kconfig
    kdePackages.kcoreaddons
    kdePackages.kdbusaddons
    kdePackages.kguiaddons
    kdePackages.ki18n
    kdePackages.kio
    kdePackages.kirigami
    kdePackages.kirigami-addons
    kdePackages.kirigami-app-components
    kdePackages.kitemmodels
    kdePackages.knotifications
    kdePackages.kparts
    kdePackages.kpty
    kdePackages.kwidgetsaddons
    kdePackages.kwindowsystem
    kdePackages.kxmlgui
    kdePackages.qqc2-desktop-style
  ];

  passthru.tests = {
    version = testers.testVersion {
      package = finalAttrs.finalPackage;
      command = "QT_QPA_PLATFORM=offscreen kwi --version";
      version = "0.1.0";
    };
  };

  meta = {
    description = "Modern and fast terminal for KDE Plasma and other desktops";
    homepage = "https://invent.kde.org/utilities/kwi";
    license = with lib.licenses; [
      gpl2Only
      gpl3Only
      lgpl21Only
      lgpl3Only
      bsd2
      cc0
    ];
    mainProgram = "kwi";
    maintainers = [ ];
    teams = [ lib.teams.qt-kde ];
    platforms = lib.platforms.linux;
  };
})

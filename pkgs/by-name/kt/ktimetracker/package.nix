{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ktimetracker";
  version = "6.0.0";

  src = fetchFromGitHub {
    owner = "KDE";
    repo = "ktimetracker";
    tag = "v${finalAttrs.version}";
    hash = "sha256-SQjqNzmmt0AEQvGW4Vz5GldQcp7Q9rZvGG7mGugRwd8=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ]
  ++ (with kdePackages; [
    extra-cmake-modules
    wrapQtAppsHook
  ]);

  buildInputs = with kdePackages; [
    kconfig
    kconfigwidgets
    kdbusaddons
    kdoctools
    ki18n
    kidletime
    kjobwidgets
    kio
    knotifications
    kwindowsystem
    kxmlgui
    ktextwidgets
    kcalendarcore
    qt5compat
    kstatusnotifieritem
    kcmutils
  ];

  meta = {
    description = "Todo management and time tracking application";
    mainProgram = "ktimetracker";
    license = lib.licenses.gpl2;
    homepage = "https://userbase.kde.org/KTimeTracker";
    maintainers = [ ];
  };
})

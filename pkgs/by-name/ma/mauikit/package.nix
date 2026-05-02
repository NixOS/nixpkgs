{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  extra-cmake-modules,
  qt6,
  kdePackages,
  mauiman,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mauikit";
  version = "4.0.2";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "maui";
    repo = "mauikit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-OHP7aDNaf/iJ/6lfY5jFlEKgdow0sD0vMCyjLhT6Y1A=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    kdePackages.ki18n
    kdePackages.kcoreaddons
    kdePackages.knotifications
    kdePackages.kwindowsystem
    mauiman
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DBUILD_DEMO=OFF"
    "-DBUNDLE_LUV_ICONS=OFF"
    "-DBUILD_SHARED_LIBS=ON"
  ];

  meta = {
    description = "Toolkit for multi-adaptable user interfaces";
    homepage = "https://invent.kde.org/maui/mauikit";
    license = lib.licenses.lgpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.sandwoodjones ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  kdePackages,
  gitUpdater,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "klassy";
  version = "6.5";

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = "klassy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-zf+RO+GolA9Gnf1/izIG7jCSu8Qlo0d0kRc90llMRIc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
    qtbase
    qtdeclarative
    qttools
    qtsvg

    frameworkintegration
    kcmutils
    kcolorscheme
    kconfig
    kcoreaddons
    kdecoration
    kguiaddons
    ki18n
    kiconthemes
    kirigami
    kwidgetsaddons
    kwindowsystem
  ];

  # Klassy tries to build for both Qt 5 and 6 at the same time by default
  # but that is impossible given how Qt setup hooks are currently designed
  # in Nixpkgs. Given that KDE Plasma 5 has already been removed as of the
  # time of writing, I figure it's fine to only build the Qt 6 version.
  cmakeFlags = [
    (lib.cmakeBool "BUILD_QT6" true)
    (lib.cmakeBool "BUILD_QT5" false)
  ];

  passthru.updateScript = gitUpdater { };

  meta = {
    description = "Highly customizable binary Window Decoration, Application Style and Global Theme plugin for recent versions of the KDE Plasma desktop";
    homepage = "https://github.com/paulmcauley/klassy";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      bsd3
      cc0
      gpl2Only
      gpl2Plus
      gpl3Only
      gpl3Plus # KDE-Accepted-GPL
      mit
    ];
    maintainers = with lib.maintainers; [ pluiedev ];
    mainProgram = "klassy-settings";
  };
})

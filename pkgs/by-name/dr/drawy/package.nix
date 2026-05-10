{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  pkg-config,
  qt6,
  shared-mime-info,
  kdePackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "drawy";
  version = "1.0.1";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    owner = "graphics";
    repo = "drawy";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Y6CAdHgcCK9lIae+CwqSGml+FAvVzLzyIAKdw85dKmQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
    shared-mime-info
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools

    kdePackages.extra-cmake-modules
    kdePackages.kconfig
    kdePackages.kconfigwidgets
    kdePackages.kcoreaddons
    kdePackages.kcrash
    kdePackages.kdoctools
    kdePackages.ki18n
    kdePackages.kiconthemes
    kdePackages.kwidgetsaddons
    kdePackages.kxmlgui
    kdePackages.syntax-highlighting
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Handy and infinite brainstorming tool";
    homepage = "https://apps.kde.org/drawy/";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      quarterstar
      sigmasquadron
      yiyu
    ];
    mainProgram = "drawy";
    platforms = lib.platforms.all;
  };
})

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

  __structuredAttrs = true;
  strictDeps = true;

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
    shared-mime-info
  ];

  buildInputs =
    (with qt6; [
      qtbase
      qttools
    ])
    ++ (with kdePackages; [
      extra-cmake-modules
      kconfig
      kconfigwidgets
      kcoreaddons
      kcrash
      kdoctools
      ki18n
      kiconthemes
      kwidgetsaddons
      kxmlgui
      syntax-highlighting
    ]);

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Handy and infinite brainstorming tool";
    homepage = "https://apps.kde.org/drawy/";
    changelog = "https://invent.kde.org/graphics/drawy/-/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = with lib.licenses; [
      bsd2
      bsd3
      cc-by-sa-40
      cc0
      gpl2Plus
      gpl3Plus
      lgpl2Plus
      mit
      ofl
    ];
    maintainers = with lib.maintainers; [
      quarterstar
      sigmasquadron
      yiyu
    ];
    mainProgram = "drawy";
    platforms = lib.platforms.all;
  };
})

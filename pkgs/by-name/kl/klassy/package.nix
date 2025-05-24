{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  kdePackages,
  qtPackages ? kdePackages,
  gitUpdater,
}:
let
  qtMajorVersion = lib.versions.major qtPackages.qtbase.version;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "klassy-qt${qtMajorVersion}";
  version = "6.3.breeze6.3.5";

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = "klassy";
    tag = finalAttrs.version;
    hash = "sha256-psXlkTo11e1Yuk85pI1KTRHl0eVdXh0bXcYbnhTa7Qk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qtPackages.extra-cmake-modules
    qtPackages.wrapQtAppsHook
  ];

  buildInputs =
    with qtPackages;
    [
      qtbase
      qtdeclarative
      qttools
      frameworkintegration
      kcmutils
      kdecoration
      kiconthemes
      kwindowsystem
    ]
    ++ lib.optionals (qtMajorVersion == "5") [
      qtx11extras
      kconfigwidgets
      kirigami2
    ]
    ++ lib.optionals (qtMajorVersion == "6") [
      qtsvg
      kcolorscheme
      kconfig
      kcoreaddons
      kdecoration
      kguiaddons
      ki18n
      kirigami
      kwidgetsaddons
    ];

  cmakeFlags = map (v: lib.cmakeBool "BUILD_QT${v}" (v == qtMajorVersion)) [
    "5"
    "6"
  ];

  passthru.updateScript = gitUpdater { };

  meta =
    {
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
    }
    // lib.optionalAttrs (qtMajorVersion == "6") {
      mainProgram = "klassy-settings";
    };
})

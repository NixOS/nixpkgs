{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  libsForQt5,

  # Could be either 5 or 6 for Qt 5 and 6 respectively.
  qtMajorVersion ? "6",
}:
let
  qtPackages =
    {
      "5" = libsForQt5;
      "6" = kdePackages;
    }
    .${qtMajorVersion};
in
assert lib.assertOneOf "qtMajorVersion" qtMajorVersion [
  "5"
  "6"
];
stdenv.mkDerivation (finalAttrs: {
  pname = "klassy";
  version = "6.1.breeze6.0.3";

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = "klassy";
    rev = finalAttrs.version;
    hash = "sha256-D8vjc8LT+pn6Qzn9cSRL/TihrLZN4Y+M3YiNLPrrREc=";
  };

  nativeBuildInputs = with qtPackages; [
    cmake
    extra-cmake-modules
    wrapQtAppsHook
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

  cmakeFlags = [
    "-DCMAKE_INSTALL_PREFIX=$out"
    "-DBUILD_TESTING=OFF"
    "-DKDE_INSTALL_USE_QT_SYS_PATHS=ON"
    "-DBUILD_QT5=OFF"
    "-DBUILD_QT6=OFF"
    "-DBUILD_QT${qtMajorVersion}=ON"
  ];

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
      # klassy-settings doesn't exist for the Qt 5 build.
      mainProgram = "klassy-settings";
    };
})

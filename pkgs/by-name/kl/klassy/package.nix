{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  kdePackages,
  libsForQt5,

  # Could be either "5" or "6" for Qt 5 and 6 respectively.
  qtMajorVersion ? "6",
}:
let
  qtMajorVersions = {
    "5" = {
      qtPackages = libsForQt5;
      extraBuildInputs = with libsForQt5; [
        qtx11extras
        kconfigwidgets
        kirigami2
      ];
      # klassy-settings doesn't exist for the Qt 5 build.
      mainProgram = null;
    };
    "6" = {
      qtPackages = kdePackages;
      extraBuildInputs = with kdePackages; [
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
      mainProgram = "klassy-settings";
    };
  };

  inherit (qtMajorVersions.${qtMajorVersion}) qtPackages extraBuildInputs mainProgram;
in
assert lib.assertOneOf "qtMajorVersion" qtMajorVersion (lib.attrNames qtMajorVersions);

stdenv.mkDerivation (finalAttrs: {
  pname = "klassy";
  version = "6.2.breeze6.2.1";

  src = fetchFromGitHub {
    owner = "paulmcauley";
    repo = "klassy";
    rev = finalAttrs.version;
    hash = "sha256-dNIDKVqY0DJ4mzH/6KDUcdqsQHOIYTbvtpQlzRsd2LY=";
  };

  nativeBuildInputs = with qtPackages; [
    cmake
    ninja
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
    ++ extraBuildInputs;

  cmakeFlags = map (v: lib.cmakeBool "BUILD_QT${v}" (qtMajorVersion == v)) (
    lib.attrNames qtMajorVersions
  );

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
    // lib.optionalAttrs (mainProgram != null) {
      inherit mainProgram;
    };
})

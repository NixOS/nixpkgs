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
  pname = "darkly-qt${qtMajorVersion}";
  version = "0.5.25";

  src = fetchFromGitHub {
    owner = "Bali10050";
    repo = "Darkly";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YffRZl5s3eFT9qJMoX0wX+5T0DmCXMhUQe6yzyd85uk=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qtPackages.wrapQtAppsHook
    qtPackages.extra-cmake-modules
  ];

  buildInputs =
    with qtPackages;
    [
      qtbase
      kconfig
      kcoreaddons
      kcmutils
      kguiaddons
      ki18n
      kiconthemes
      kwindowsystem
    ]
    ++ lib.optionals (qtMajorVersion == "5") [
      kirigami2
    ]
    ++ lib.optionals (qtMajorVersion == "6") [
      kcolorscheme
      kdecoration
      kirigami
    ];

  cmakeFlags = map (v: lib.cmakeBool "BUILD_QT${v}" (v == qtMajorVersion)) [
    "5"
    "6"
  ];

  passthru.updateScript = gitUpdater { rev-prefix = "v"; };

  meta = {
    description = "Modern style for Qt applications (fork of Lightly)";
    homepage = "https://github.com/Bali10050/Darkly";
    changelog = "https://github.com/Bali10050/Darkly/releases/tag/v${finalAttrs.version}";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [ gpl2Plus ];
    maintainers = with lib.maintainers; [ pluiedev ];
  }
  // lib.optionalAttrs (qtMajorVersion == "6") {
    mainProgram = "darkly-settings6";
  };
})

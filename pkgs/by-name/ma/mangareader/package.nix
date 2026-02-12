{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "mangareader";
  version = "2.3.0";

  src = fetchFromGitHub {
    owner = "g-fb";
    repo = "mangareader";
    rev = finalAttrs.version;
    hash = "sha256-G/X8iJxEMNCSI0whxIpmzFh/Y/Hbr9vvzcGsbb8arig=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = with kdePackages; [
    qtbase
    kio
    ki18n
    kxmlgui
    kconfig
    karchive
    kcoreaddons
    kconfigwidgets
    qtwayland
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Qt manga reader for local files";
    homepage = "https://github.com/g-fb/mangareader";
    changelog = "https://github.com/g-fb/mangareader/releases/tag/${finalAttrs.src.rev}";
    mainProgram = "mangareader";
    platforms = lib.platforms.linux;
    license = with lib.licenses; [
      gpl3Plus
      cc-by-sa-40
    ];
    maintainers = with lib.maintainers; [ zendo ];
  };
})

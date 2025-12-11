{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  pkg-config,
  hyprutils,
  hyprland-qt-support,
  pciutils,
  qt6,
}:
let
  inherit (lib.strings) makeBinPath;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland-qtutils";
  version = "0.1.5";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-qtutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bTYedtQFqqVBAh42scgX7+S3O6XKLnT6FTC6rpmyCCc=";
  };

  patches = [
    # this should be removed in the next release
    (fetchpatch {
      name = "Fix build with Qt 6.10";
      url = "https://github.com/hyprwm/hyprland-qtutils/commit/5ffdfc13ed03df1dae5084468d935f0a3f2c9a4c.patch";
      hash = "sha256-5nVj4AFJpmazX9o9tQD6mzBW9KtRYov4yRbGpUwFcgc=";
    })
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    hyprutils
    hyprland-qt-support
    qt6.qtbase
    qt6.qtsvg
    qt6.qtwayland
  ];

  preFixup = ''
    qtWrapperArgs+=(--prefix PATH : "${makeBinPath [ pciutils ]}")
  '';

  meta = {
    description = "Hyprland QT/qml utility apps";
    homepage = "https://github.com/hyprwm/hyprland-qtutils";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = lib.platforms.linux;
  };
})

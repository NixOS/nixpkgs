{
  lib,
  stdenv,
  fetchFromGitHub,
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

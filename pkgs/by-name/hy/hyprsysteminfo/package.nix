{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  pkg-config,
  hyprutils,
  pciutils,
  hyprland-qt-support,
}:
let
  inherit (lib.strings) makeBinPath;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprsysteminfo";
  version = "0.1.3";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprsysteminfo";
    tag = "v${finalAttrs.version}";
    hash = "sha256-KDxT9B+1SATWiZdUBAQvZu17vk3xmyXcw2Zy56bdWbY=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtwayland
    hyprutils
    hyprland-qt-support
  ];

  preFixup = ''
    qtWrapperArgs+=(--prefix PATH : "${makeBinPath [ pciutils ]}")
  '';

  meta = {
    description = "Tiny qt6/qml application to display information about the running system";
    homepage = "https://github.com/hyprwm/hyprsysteminfo";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    mainProgram = "hyprsysteminfo";
    platforms = lib.platforms.linux;
  };
})

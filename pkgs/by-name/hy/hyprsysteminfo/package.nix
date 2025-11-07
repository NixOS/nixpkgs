{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
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

  patches = [
    # Fix Qt6::WaylandClientPrivate not found
    # https://github.com/hyprwm/hyprsysteminfo/pull/21
    (fetchpatch {
      url = "https://github.com/hyprwm/hyprsysteminfo/commit/fe81610278676d26ff47f62770ac238220285d3a.patch";
      hash = "sha256-rfKyV0gkfXEhTcPHlAB+yxZ+92umBV22YOK9aLMMBhM=";
    })
  ];

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

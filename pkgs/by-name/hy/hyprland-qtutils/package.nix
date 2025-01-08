{
  lib,
  gcc14Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprutils,
  pciutils,
  qt6,
}:
let
  inherit (lib.strings) makeBinPath;
in
gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland-qtutils";
  version = "0.1.1";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-qtutils";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Zp2cQOo1D7WH7ml5nV7mLyto0l19gTaWnbDb6zty1Qs=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    hyprutils
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
    maintainers = [ lib.maintainers.fufexan ];
    platforms = lib.platforms.linux;
  };
})

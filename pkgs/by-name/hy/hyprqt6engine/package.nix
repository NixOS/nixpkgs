{
  lib,
  gcc14Stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprlang,
  hyprutils,
  hyprland-qt-support,
  qt6,
  kdePackages,
}:
gcc14Stdenv.mkDerivation (finalAttrs: {
  pname = "hyprqt6engine";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprqt6engine";
    rev = "v${finalAttrs.version}";
    sha256 = "sha256-WSUMQmfVlpz31o2Tgfue0jnVRCeTrRi3Cy6s2/o8hzQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    hyprutils
    hyprlang
    hyprland-qt-support
    qt6.qtbase
    kdePackages.kiconthemes
  ];

  cmakeFlags = [
    "-DPLUGINDIR:PATH=$out/lib/qt-6/plugins"
  ];

  meta = {
    description = "QT6 Theme Provider for Hyprland";
    homepage = "https://github.com/hyprwm/hyprqt6engine";
    license = lib.licenses.bsd3;
    teams = [ lib.teams.hyprland ];
    platforms = lib.platforms.linux;
  };
})

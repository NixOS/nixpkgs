{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  pkg-config,
  hyprlang,
  hyprutils,
  qt6Packages,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprqt6engine";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprqt6engine";
    tag = "v${finalAttrs.version}";
    hash = "sha256-WSUMQmfVlpz31o2Tgfue0jnVRCeTrRi3Cy6s2/o8hzQ=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    hyprlang
    hyprutils
    qt6Packages.qtbase
  ];

  dontWrapQtApps = true;

  cmakeFlags = lib.mapAttrsToList lib.cmakeFeature {
    PLUGINDIR = "${placeholder "out"}/lib/qt-6";
  };

  meta = {
    homepage = "https://github.com/hyprwm/hyprqt6engine";
    description = "Qt6 theme provider for Hyprland";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.kruziikrel13 ];
    teams = [ lib.teams.hyprland ];
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  ninja,
  qt6,
  pkg-config,
  hyprlang,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "hyprland-qt-support";
  version = "0.1.0";

  src = fetchFromGitHub {
    owner = "hyprwm";
    repo = "hyprland-qt-support";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+uZovj+X0a28172y0o0BvgGXyZLpKPbG03sVlCiSrWc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtdeclarative
    qt6.qtsvg
    qt6.qtwayland
    hyprlang
  ];

  cmakeFlags = [
    (lib.cmakeFeature "INSTALL_QML_PREFIX" qt6.qtbase.qtQmlPrefix)
  ];

  meta = {
    description = "Qt6 QML provider for hypr* apps";
    homepage = "https://github.com/hyprwm/hyprland-qt-support";
    license = lib.licenses.bsd3;
    platforms = lib.platforms.linux;
    teams = [ lib.teams.hyprland ];
  };
})

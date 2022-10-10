{
  stdenv,
  lib,

  fetchFromGitLab,

  wrapQtAppsHook,
  meson,
  pkg-config,
  cmake,
  qttools,
  ninja,

  qtbase,
  json_c,
  wlroots,
  wayqt,
  wayland,
  pixman
}:

stdenv.mkDerivation {
  pname = "qtgreet";
  version = "unstable-2022-01-24"; # Couldn't get 1.0.0 to build

  src = fetchFromGitLab {
    owner = "marcusbritanicus";
    repo = "qtgreet";
    rev = "04e0160ed40c0bb837a1cdae67d764e094dea859";
    hash = "sha256-hY5lATF9yQCuGqrftUpZy0OdO+uRtM/Rm3GguU74Nb8=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    meson
    pkg-config
    cmake
    qttools # lrelease
    ninja
  ];

  buildInputs = [
    qtbase
    json_c
    wlroots
    wayqt
    wayland
    pixman
  ];

  meta = with lib; {
    homepage = "https://gitlab.com/marcusbritanicus/QtGreet";
    description = "Qt based greeter for greetd, to be run under wayfire or similar wlr-based compositors";
    maintainers = with maintainers; [ atemu ];
    platforms = platforms.linux;
    license = licenses.gpl3Only;
  };
}

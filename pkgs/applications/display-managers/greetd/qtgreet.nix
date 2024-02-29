{ stdenv
, lib
, fetchFromGitLab
, pkg-config
, meson
, ninja
, qtbase
, qttools
, qtwayland
, wrapQtAppsHook
, dfl-applications
, dfl-ipc
, dfl-login1
, dfl-utils
, wayqt
, wayland
, wlroots
, cmake
, mpv
, pixman
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtgreet";
  version = "2.0.1";

  src = fetchFromGitLab {
    owner = "marcusbritanicus";
    repo = "QtGreet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-Lm7OdB9/o7BltPusuxTIuPQ4w23rCIKugEsjGR5vgVg=";
  };

  nativeBuildInputs = [
    wrapQtAppsHook
    pkg-config
    meson
    ninja
    qttools
    cmake
  ];

  buildInputs = [
    qtbase
    wlroots
    wayqt
    wayland
    dfl-applications
    dfl-ipc
    dfl-login1
    dfl-utils
    mpv
    pixman
    qtwayland
  ];

  mesonFlags = [
    "-Duse_qt_version=qt6"
    "-Dnodynpath=true"
  ];

  meta = with lib; {
    description = "Qt based greeter for greetd, to be run under wayfire or similar wlr-based compositors.";
    homepage = "https://gitlab.com/marcusbritanicus/QtGreet";
    maintainers = with maintainers; [ sreehax ];
    license = licenses.gpl3Only;
    platforms = platforms.linux;
    mainProgram = "qtgreet";
  };
})

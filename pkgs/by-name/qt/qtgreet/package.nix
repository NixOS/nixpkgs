{
  lib,
  stdenv,
  fetchFromGitLab,
  meson,
  ninja,
  pkg-config,
  kdePackages,
  qt6,
  dfl-ipc,
  dfl-utils,
  dfl-applications,
  dfl-login1,
  mpvSupport ? true,
  mpv,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtgreet";
  version = "2.0.4";

  src = fetchFromGitLab {
    owner = "marcusbritanicus";
    repo = "QtGreet";
    rev = "v${finalAttrs.version}";
    hash = "sha256-5csKvBiffW+yHuNyFqxOE5bcsTWlyoLwFxuPH0WlFAE=";
  };

  nativeBuildInputs = [
    meson
    ninja
    pkg-config
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.wayqt
    qt6.qtbase
    dfl-ipc
    dfl-utils
    dfl-applications
    dfl-login1
  ]
  ++ lib.optionals mpvSupport [ mpv ];

  mesonFlags = [
    (lib.mesonOption "dynpath" "${placeholder "out"}/var/lib/qtgreet")
  ];

  meta = {
    description = "Qt based greeter for greetd, to be run under wayfire or similar wlr-based compositors";
    homepage = "https://gitlab.com/marcusbritanicus/QtGreet";
    changelog = "https://gitlab.com/marcusbritanicus/QtGreet/-/blob/${finalAttrs.src.rev}/Changelog";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ arthsmn ];
    mainProgram = "qtgreet";
    platforms = lib.platforms.linux;
  };
})

{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  pkg-config,
  qt6Packages,
  qt6integration,
  qt6platform-plugins,
  dtk6declarative,
  dde-shell,
}:

stdenv.mkDerivation rec {
  pname = "dde-launchpad";
  version = "1.0.2";

  src = fetchFromGitHub {
    owner = "linuxdeepin";
    repo = pname;
    rev = version;
    hash = "sha256-kczdSd9+ZmMZQ2fWg3SRW+CS/aWktYLz/H+Ky81TwVM=";
  };

  nativeBuildInputs = [
    cmake
    pkg-config
    qt6Packages.qttools
    qt6Packages.wrapQtAppsHook
  ];

  buildInputs =
    [
      qt6integration
      qt6platform-plugins
      dtk6declarative
      dde-shell
    ]
    ++ (with qt6Packages; [
      qtbase
      qtsvg
      qtwayland
      appstream-qt
    ]);

  cmakeFlags = [ "-DSYSTEMD_USER_UNIT_DIR=${placeholder "out"}/lib/systemd/user" ];

  meta = {
    description = "'launcher' or 'start menu' component for DDE";
    mainProgram = "dde-launchpad";
    homepage = "https://github.com/linuxdeepin/dde-launchpad";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = lib.teams.deepin.members;
  };
}

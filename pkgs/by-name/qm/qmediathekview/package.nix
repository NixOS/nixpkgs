{
  lib,
  stdenv,
  fetchFromGitHub,
  boost,
  xz,
  cargo,
  pkg-config,
  qt6Packages,
  rustPlatform,
  sqlite,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "QMediathekView";
  version = "0.2.3";

  src = fetchFromGitHub {
    owner = "adamreichold";
    repo = "QMediathekView";
    tag = "v${finalAttrs.version}";
    hash = "sha256-miqCzNTqbZwPuy6P911wlf5TF1lECzNW/02/edK8XaU=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      cargoRoot
      ;
    hash = "sha256-89ogtmtJRgMoPOjyW+OGoptKE8VP9lUhbsB5vrdP7zQ=";
  };

  postPatch = ''
    substituteInPlace QMediathekView.pro \
      --replace /usr ""
  '';

  buildInputs = [
    qt6Packages.qtbase
    sqlite
    xz
    boost
  ];

  nativeBuildInputs = [
    qt6Packages.qmake
    cargo
    pkg-config
    qt6Packages.wrapQtAppsHook
    rustPlatform.cargoSetupHook
  ];

  cargoRoot = "internals";

  env.HOST_AR = lib.getExe' stdenv.cc.bintools.bintools "ar";

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  meta = {
    description = "Alternative Qt-based front-end for the database maintained by the MediathekView project";
    inherit (finalAttrs.src.meta) homepage;
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ dotlambda ];
    broken = stdenv.hostPlatform.isAarch64;
    mainProgram = "QMediathekView";
  };
})

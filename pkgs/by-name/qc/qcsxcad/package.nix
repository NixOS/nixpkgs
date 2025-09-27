{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  csxcad,
  tinyxml,
  vtkWithQt6,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qcsxcad";
  version = "0.6.3";

  src = fetchFromGitHub {
    owner = "thliebig";
    repo = "QCSXCAD";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bX6e3ugHJynU9tP70BV8TadnoGg1VO7SAYJueMkMAyo=";
  };

  outputs = [
    "out"
    "dev"
  ];

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    (lib.cmakeBool "ENABLE_RPATH" false)
  ];

  buildInputs = [
    csxcad
    tinyxml
    vtkWithQt6
    qt6.qtbase
    qt6.qt5compat
    qt6.qtwayland
  ];

  dontWrapQtApps = true;

  meta = {
    description = "Qt library for CSXCAD";
    homepage = "https://github.com/thliebig/QCSXCAD";
    license = lib.licenses.gpl3;
    maintainers = with lib.maintainers; [ matthuszagh ];
    platforms = lib.platforms.linux;
  };
})

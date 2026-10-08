{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
}:

stdenv.mkDerivation (finalAttrs: {
  version = "2.1.0-unstable-2020-06-26";
  pname = "herqq";

  strictDeps = true;
  __structuredAttrs = true;

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.qtmultimedia
    libsForQt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qtmultimedia
  ];

  outputs = [
    "out"
    "dev"
  ];

  sourceRoot = "${finalAttrs.src.name}/herqq";
  src = fetchFromGitHub {
    owner = "ThomArmax";
    repo = "HUPnP";
    rev = "c8385a8846b52def7058ae3794249d6b566a41fc";
    hash = "sha256-FxN/QlLB3sZ6Vn/9VIKNUntX/B4+crQZ7t760pwFqY8=";
  };

  meta = {
    homepage = "https://github.com/ThomArmax/HUPnP";
    description = "Software library for building UPnP devices and control points";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Only;
    maintainers = [ ];
  };
})

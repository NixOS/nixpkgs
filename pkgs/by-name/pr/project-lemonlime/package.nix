{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "project-lemonlime";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "Project-LemonLime";
    repo = "Project_LemonLime";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-h/aE1+ED+RkXqFcsb23rboA+Dd7kiom3XiIRqb4oYkQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qt5.wrapQtAppsHook
  ];

  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qt5.qttools
  ];

  meta = {
    description = "Lightweight evaluation system based on Lemon + LemonPlus for OI competitions";
    homepage = "https://github.com/Project-LemonLime/Project_LemonLime";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ sigmanificient ];
    platforms = lib.platforms.unix;
    broken = stdenv.isDarwin;
  };
})

{
  stdenv,
  fetchFromGitHub,
  cmake,
  libsForQt5,
  qt5,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "project_lemonlime";
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
})

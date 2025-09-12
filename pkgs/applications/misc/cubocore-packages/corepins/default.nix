{
  lib,
  stdenv,
  fetchFromGitLab,
  qt6,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corepins";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corepins";
    tag = "v${finalAttrs.version}";
    hash = "sha256-noMdI2qk3cYc1FfRWd4rwpZBbeHiD557Z1T0ZxIhaTw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    libcprime
    libcsys
  ];

  meta = {
    description = "Bookmarking app from the C Suite";
    mainProgram = "corepins";
    homepage = "https://gitlab.com/cubocore/coreapps/corepins";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchFromGitLab,
  qt6,
  libarchive,
  libarchive-qt,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corearchiver";
  version = "5.0.1";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corearchiver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-r2iXvc9KtRsB5IHvJxs/DxQIf7IiNWoM4h2wDgsXvZE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    libarchive-qt
    libarchive
    libcprime
    libcsys
  ];

  meta = {
    description = "Archiver from the C Suite to create and extract archives";
    mainProgram = "corearchiver";
    homepage = "https://gitlab.com/cubocore/coreapps/corearchiver";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

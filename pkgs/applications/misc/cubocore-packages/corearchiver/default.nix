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
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corearchiver";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+XaBe1fNpAQf3cqXV+A1cZ1tPck3bCpgEDmFeF536q4=";
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

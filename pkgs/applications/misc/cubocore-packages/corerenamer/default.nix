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
  pname = "corerenamer";
  version = "5.0.1";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corerenamer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-94luETLmugQZuSI+q84DC9WyH5LtCqpjH6LYtv9R93Y=";
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
    description = "Batch file renamer from the C Suite";
    mainProgram = "corerenamer";
    homepage = "https://gitlab.com/cubocore/coreapps/corerenamer";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

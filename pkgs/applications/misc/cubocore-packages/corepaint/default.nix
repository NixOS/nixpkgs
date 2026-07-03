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
  pname = "corepaint";
  version = "5.0.1";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corepaint";
    tag = "v${finalAttrs.version}";
    hash = "sha256-qk2Fm/IhUU/0y+ErMK/qQKxnD/en14ZKoiIJoJwBnMc=";
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
    description = "Paint app from the C Suite";
    mainProgram = "corepaint";
    homepage = "https://gitlab.com/cubocore/coreapps/corepaint";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

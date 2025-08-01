{
  lib,
  stdenv,
  fetchFromGitLab,
  kdePackages,
  cmake,
  ninja,
  pkg-config,
  libcprime,
  libcsys,
  qdocumentview,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corepdf";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corepdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-fhEuMk15yCA6IUasD9rJPR8sB+h0tz8niOQtXFIe7Uc=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.qtbase
    kdePackages.qtwebengine
    kdePackages.poppler
    qdocumentview
    libcprime
    libcsys
  ];

  meta = {
    description = "PDF viewer from the C Suite";
    mainProgram = "corepdf";
    homepage = "https://gitlab.com/cubocore/coreapps/corepdf";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})

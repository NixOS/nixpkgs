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
  version = "5.0.1";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corepdf";
    tag = "v${finalAttrs.version}";
    hash = "sha256-6VLjOf/VZpBH8kIvdvObiyu10yiTYk26eKHFKIUMwN8=";
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
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

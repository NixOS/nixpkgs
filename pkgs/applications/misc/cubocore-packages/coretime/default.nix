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
  pname = "coretime";
  version = "5.0.1";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "coretime";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RgaIYZ410/M/PHTJC3ja7wEb3HqPrNkBpEIsUK102qw=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtmultimedia
    libcprime
    libcsys
  ];

  meta = {
    description = "Time related task manager from the C Suite";
    mainProgram = "coretime";
    homepage = "https://gitlab.com/cubocore/coreapps/coretime";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})

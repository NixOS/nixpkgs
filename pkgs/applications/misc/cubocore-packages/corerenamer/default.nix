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
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corerenamer";
    tag = "v${finalAttrs.version}";
    hash = "sha256-9e8Gm7h0zWVQeb7eFcUmp8uTdSboenLa7baZpKc3HEQ=";
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

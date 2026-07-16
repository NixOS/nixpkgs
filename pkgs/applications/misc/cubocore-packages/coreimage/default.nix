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
  pname = "coreimage";
  version = "5.0.1";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "coreimage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-1P6dD0aHsv79s1jCghRhhxi5rZ6MmpyIrks9QnqFoaU=";
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
    description = "Image viewer from the C Suite";
    mainProgram = "coreimage";
    homepage = "https://gitlab.com/cubocore/coreapps/coreimage";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

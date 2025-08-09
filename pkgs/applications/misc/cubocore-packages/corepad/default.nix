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
  pname = "corepad";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corepad";
    tag = "v${finalAttrs.version}";
    hash = "sha256-oGF2N0bUuvc/ixmh2nefEJKh0kDipvcL/dwaXNxwo84=";
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
    description = "Document editor from the C Suite";
    mainProgram = "corepad";
    homepage = "https://gitlab.com/cubocore/coreapps/corepad";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})

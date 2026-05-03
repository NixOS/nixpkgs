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
  pname = "coreaction";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "coreaction";
    tag = "v${finalAttrs.version}";
    hash = "sha256-R/pzudaxs85etbI4hh2NwHNtO7EqI+vgJALY/4rIvrs=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtsvg
    qt6.qtbase
    libcprime
    libcsys
  ];

  meta = {
    description = "Side bar for showing widgets from the C Suite";
    mainProgram = "coreaction";
    homepage = "https://gitlab.com/cubocore/coreapps/coreaction";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

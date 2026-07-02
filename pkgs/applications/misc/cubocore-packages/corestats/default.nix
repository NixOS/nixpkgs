{
  lib,
  stdenv,
  fetchFromGitLab,
  qt6,
  lm_sensors,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corestats";
  version = "5.0.1";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corestats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4wVBC/NeexJIFsDOjqHFC/u3Rapd/22fjH5yMVafWPY=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    lm_sensors
    libcprime
    libcsys
  ];

  meta = {
    description = "System resource viewer from the C Suite";
    mainProgram = "corestats";
    homepage = "https://gitlab.com/cubocore/coreapps/corestats";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchFromGitLab,
  qt6,
  qtermwidget,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "coreterminal";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "coreterminal";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CSPZ1mbZ5ylfMQAwzj+hNodhEuyC7klvlKU5bj+HiyE=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qtserialport
    qtermwidget
    libcprime
    libcsys
  ];

  meta = {
    description = "Terminal emulator from the C Suite";
    mainProgram = "coreterminal";
    homepage = "https://gitlab.com/cubocore/coreapps/coreterminal";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})

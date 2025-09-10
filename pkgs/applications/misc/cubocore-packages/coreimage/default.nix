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
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "coreimage";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sgOxDKACb9D/TvjjHz09JwBpFoE8eXA4HixcbN+0FoE=";
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})

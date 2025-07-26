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
  pname = "corehunt";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corehunt";
    tag = "v${finalAttrs.version}";
    hash = "sha256-QJJ+e+5UKka1Hbrtyn+agpJ7FLADHupZt41K8Mq8H4c=";
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
    description = "File finder utility from the C Suite";
    mainProgram = "corehunt";
    homepage = "https://gitlab.com/cubocore/coreapps/corehunt";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})

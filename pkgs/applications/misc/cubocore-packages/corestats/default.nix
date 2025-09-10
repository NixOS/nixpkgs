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
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corestats";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0d03y3AYWxXh9DZrbPWqk34yq7iy5xUn/oMmJBu5GqQ=";
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
    maintainers = with lib.maintainers; [ ];
    platforms = lib.platforms.linux;
  };
})

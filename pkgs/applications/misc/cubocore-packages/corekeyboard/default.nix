{
  lib,
  stdenv,
  fetchFromGitLab,
  qt6,
  xorg,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "corekeyboard";
  version = "5.0.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = "corekeyboard";
    tag = "v${finalAttrs.version}";
    hash = "sha256-n7QbvRPZFMeUl/P4XiGYZDglZCA8Ftf08s5uzPmSyIQ=";
  };

  nativeBuildInputs = [
    cmake
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtbase
    xorg.libXtst
    xorg.libX11
    libcprime
    libcsys
  ];

  meta = {
    description = "Virtual keyboard for X11 from the C Suite";
    mainProgram = "corekeyboard";
    homepage = "https://gitlab.com/cubocore/coreapps/corekeyboard";
    license = lib.licenses.gpl3Plus;
    maintainers = [ ];
    platforms = lib.platforms.linux;
  };
})

{
  mkDerivation,
  lib,
  fetchFromGitLab,
  qtbase,
  qtx11extras,
  xorg,
  cmake,
  ninja,
  libcprime,
  libcsys,
}:

mkDerivation rec {
  pname = "corekeyboard";
  version = "4.5.0";

  src = fetchFromGitLab {
    owner = "cubocore/coreapps";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-Hylz1x9Wsk0iVhpNBFZJChsl3gIvJDICgpITjIXDZAg=";
  };

  nativeBuildInputs = [
    cmake
    ninja
  ];

  buildInputs = [
    qtbase
    qtx11extras
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
    maintainers = with lib.maintainers; [ dan4ik605743 ];
    platforms = lib.platforms.linux;
  };
}

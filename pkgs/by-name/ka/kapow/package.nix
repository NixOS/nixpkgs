{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  qt6,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kapow";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "gottcode";
    repo = "kapow";
    rev = "v${finalAttrs.version}";
    hash = "sha256-gBr1CmOpwJOqolY6HA4fv7YCaFSeRmxbJeVkZCau9QE=";
  };

  nativeBuildInputs = [
    cmake
    qt6.qmake
    qt6.qttools
    qt6.wrapQtAppsHook
  ];

  buildInputs = [ qt6.qtbase ];

  meta = {
    description = "Punch clock to track time spent on projects";
    mainProgram = "kapow";
    homepage = "https://gottcode.org/kapow/";
    maintainers = with lib.maintainers; [ tbutter ];
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl3Plus;
  };
})

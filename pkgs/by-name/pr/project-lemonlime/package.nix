{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "project-lemonlime";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "Project-LemonLime";
    repo = "Project_LemonLime";
    rev = "refs/tags/${finalAttrs.version}";
    hash = "sha256-h/aE1+ED+RkXqFcsb23rboA+Dd7kiom3XiIRqb4oYkQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  cmakeFlags = [
    (lib.cmakeBool "LEMON_QT6" true)
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6.qtwayland
  ];

  meta = {
    description = "Lightweight evaluation system based on Lemon + LemonPlus for OI competitions";
    homepage = "https://github.com/Project-LemonLime/Project_LemonLime";
    changelog = "https://github.com/Project-LemonLime/Project_LemonLime/releases/tag/${finalAttrs.version}";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [
      sigmanificient
      bot-wxt1221
    ];
    platforms = lib.platforms.unix;
    mainProgram = "lemon";
  };
})

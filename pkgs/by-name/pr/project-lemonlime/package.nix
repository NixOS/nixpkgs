{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  nix-update-script,
  bubblewrap,
  bash,
  diffutils,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "project-lemonlime";
  version = "0.3.5";

  src = fetchFromGitHub {
    owner = "Project-LemonLime";
    repo = "Project_LemonLime";
    tag = finalAttrs.version;
    hash = "sha256-h/aE1+ED+RkXqFcsb23rboA+Dd7kiom3XiIRqb4oYkQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    qt6.wrapQtAppsHook
  ];

  patches = [
    ./0001-Bind-Nix-Store.patch
  ];

  postPatch = ''
    substituteInPlace src/core/judgingthread.cpp \
      --replace-fail "/usr/bin/bwrap" "${lib.getExe bubblewrap}"
    substituteInPlace unix/watcher_unix.cpp \
      --replace-fail "bash" "${lib.getExe bash}"
    substituteInPlace src/base/settings.cpp \
      --replace-fail "/usr/bin/diff" "${diffutils}/bin/diff"
  '';

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
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [
      sigmanificient
      bot-wxt1221
    ];
    platforms = lib.platforms.unix;
    mainProgram = "lemon";
  };
})

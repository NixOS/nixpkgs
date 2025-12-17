{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "qtappinstancemanager";
  version = "1.3.1";

  src = fetchFromGitHub {
    owner = "oclero";
    repo = "qtappinstancemanager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+YkvWv5ss4O1WLDmwpueuRY72tTdXTLZeg8pVL4R3Ag=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    qt6.qtbase
  ];

  dontWrapQtApps = true;

  passthru = {
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Single application instance manager for Qt6";
    homepage = "https://github.com/oclero/qtappinstancemanager";
    changelog = "https://github.com/oclero/qtappinstancemanager/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ normalcea ];
    mainProgram = "qtappinstancemanager";
    platforms = lib.platforms.all;
  };
})

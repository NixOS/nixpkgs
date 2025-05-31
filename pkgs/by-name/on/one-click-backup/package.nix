{
  lib,
  stdenv,
  fetchFromGitLab,
  cmake,
  ninja,
  qt6,
  extra-cmake-modules,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "one-click-backup";
  version = "1.2.2.1";

  src = fetchFromGitLab {
    owner = "dev-nis";
    repo = "nis-one-click-backup-qt";
    rev = finalAttrs.version;
    hash = "sha256-F+gA+Z4gZoNJYdy28uIjqiJcwcNsyUzl6BXsiIZO0gE=";
  };

  nativeBuildInputs = [
    cmake
    extra-cmake-modules
    ninja
    qt6.wrapQtAppsHook
  ];

  buildInputs = [
    qt6.qtdeclarative
  ];

  meta = with lib; {
    description = "Simple Program to backup folders to an external location by copying them";
    homepage = "https://gitlab.com/dev-nis/nis-one-click-backup-qt";
    changelog = "https://gitlab.com/dev-nis/nis-one-click-backup-qt/-/blob/${finalAttrs.version}/CHANGELOG.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ NIS ];
    mainProgram = "NIS_One-Click-Backup_Qt";
    platforms = platforms.all;
    broken = stdenv.hostPlatform.isDarwin;
  };
})

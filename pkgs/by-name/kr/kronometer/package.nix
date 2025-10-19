{
  stdenv,
  fetchFromGitLab,
  lib,
  nix-update-script,
  kdePackages,
  cmake,
  gettext,
}:

stdenv.mkDerivation {
  pname = "kronometer";
  version = "2.3.0-unstable-2025-10-18";

  src = fetchFromGitLab {
    domain = "invent.kde.org";
    repo = "kronometer";
    owner = "utilities";
    rev = "6b83344d65f4e039b947d15261c11ae80ed3900d";
    hash = "sha256-0DDPjL4VDsz8h9c1WfGEoE/ISTGIPUQpjwvP+1Q6Tqk=";
  };

  strictDeps = true;

  depsBuildBuild = [
    cmake
  ];

  nativeBuildInputs = [
    cmake
    gettext
    kdePackages.extra-cmake-modules
    kdePackages.kdoctools
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.kconfig
    kdePackages.kcrash
    kdePackages.kxmlgui
    kdePackages.qtbase
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    homepage = "https://kde.org/applications/utilities/kronometer/";
    description = "Stopwatch application";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ peterhoeg ];
    mainProgram = "kronometer";
  };
}

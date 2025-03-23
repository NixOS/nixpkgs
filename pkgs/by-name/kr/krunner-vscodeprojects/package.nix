{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  kdePackages,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "krunner-vscodeprojects";
  version = "2.0.2";

  src = fetchFromGitHub {
    owner = "alex1701c";
    repo = "krunner-vscodeprojects";
    rev = version;
    hash = "sha256-a24MFSXYFR4VVUVMOAY0n0sKqY0L9lUhnpgSeDFtceI=";
  };

  dontWrapQtApps = true;

  buildInputs = with kdePackages; [
    ki18n
    krunner
    kconfig
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
  ];

  cmakeFlags = [
    "-DBUILD_WITH_QT6=ON"
    "-DQT_MAJOR_VERSION=6"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Krunner Plugin which allows you to open your VSCode Project Manager projects";
    homepage = "https://github.com/alex1701c/krunner-vscodeprojects";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ js6pak ];
    inherit (kdePackages.krunner.meta) platforms;
  };
}

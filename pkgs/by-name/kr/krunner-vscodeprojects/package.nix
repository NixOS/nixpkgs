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
  version = "2.0.1";

  src = fetchFromGitHub {
    owner = "alex1701c";
    repo = "krunner-vscodeprojects";
    rev = version;
    hash = "sha256-M2zy9tFd4kk/6uo6xrMTm/Rc6+mIW04YCcl7jXqFEmQ=";
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
    description = "A Krunner Plugin which allows you to open your VSCode Project Manager projects";
    homepage = "https://github.com/alex1701c/krunner-vscodeprojects";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.lgpl3;
    maintainers = with lib.maintainers; [ js6pak ];
    inherit (kdePackages.krunner.meta) platforms;
  };
}

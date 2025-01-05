{
  stdenv,
  lib,
  fetchFromGitHub,
  cmake,
  kdePackages,
  nix-update-script,
}:
stdenv.mkDerivation rec {
  pname = "jetbrains-runner";
  version = "3.0.4";

  src = fetchFromGitHub {
    owner = "alex1701c";
    repo = "JetBrainsRunner";
    rev = version;
    hash = "sha256-uLUtxKGXa8MjpdrT7X0EpRCWQTBYm8mt0NcyOLoGd5Y=";
    fetchSubmodules = true;
  };

  dontWrapQtApps = true;

  buildInputs = with kdePackages; [
    ki18n
    kservice
    krunner
    ktextwidgets
    kio
    kcmutils
  ];

  nativeBuildInputs = [
    cmake
    kdePackages.extra-cmake-modules
  ];

  cmakeFlags = [
    "-DBUILD_TESTING=OFF"
    "-DBUILD_WITH_QT6=ON"
    "-DQT_MAJOR_VERSION=6"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Krunner Plugin which allows you to open your recent JetBrains projects";
    homepage = "https://github.com/alex1701c/JetBrainsRunner";
    sourceProvenance = with lib.sourceTypes; [ fromSource ];
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ js6pak ];
    inherit (kdePackages.krunner.meta) platforms;
  };
}

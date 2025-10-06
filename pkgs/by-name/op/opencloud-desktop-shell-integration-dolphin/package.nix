{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  qt6,
  kdePackages,
  opencloud-desktop-shell-integration-resources,
}:

stdenv.mkDerivation rec {
  pname = "opencloud-desktop-shell-integration-dolphin";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "opencloud-eu";
    repo = "desktop-shell-integration-dolphin";
    tag = "v${version}";
    hash = "sha256-+Bu/kN4RvR/inWQHYcfWOF6BWHTFm5jlea/QeT4NhFQ=";
  };

  buildInputs = [
    qt6.qtbase
    kdePackages.extra-cmake-modules
    kdePackages.kbookmarks
    kdePackages.kcoreaddons
    kdePackages.kio
    opencloud-desktop-shell-integration-resources
  ];

  nativeBuildInputs = [
    cmake
  ];

  dontWrapQtApps = true;

  meta = {
    description = "OpenCloud Desktop shell integration for the great KDE Dolphin in KDE Frameworks 6";
    homepage = "https://github.com/opencloud-eu/desktop-shell-integration-dolphin";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ k900 ];
    mainProgram = "opencloud-desktop-shell-integration-dolphin";
    platforms = lib.platforms.all;
  };
}

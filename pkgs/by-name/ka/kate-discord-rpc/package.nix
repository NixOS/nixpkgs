{
  lib,
  stdenv,
  cmake,
  fetchFromGitHub,
  kdePackages,
  qt6,
  rapidjson,
  unstableGitUpdater,
  ...
}:
stdenv.mkDerivation (finalAttrs: {
  __structuredAttrs = true;
  pname = "kate-discord-rpc";
  version = "0-unstable-2026-03-17";

  src = fetchFromGitHub {
    owner = "leia-uwu";
    repo = "kate-discord-rpc";
    rev = "93a14a03887540f819b3b4885fd8c789aee05b19";
    hash = "sha256-TWMYy6oeFJZ1WTS9tNQLk9RcRBwkvVrZy9kVU2Kr90s=";
    fetchSubmodules = true;
  };

  enableParallelBuilding = true;
  strictDeps = true;

  buildInputs = [
    kdePackages.extra-cmake-modules
    kdePackages.kcoreaddons
    kdePackages.kconfig
    kdePackages.ktexteditor
    kdePackages.kwidgetsaddons
    kdePackages.qtbase
    qt6.wrapQtAppsHook
    rapidjson
  ];

  nativeBuildInputs = [
    cmake
  ];

  passthru.updateScript = unstableGitUpdater { };

  meta = {
    description = "Discord Rich Presence plugin for the KDE Plasma text editor Kate";
    homepage = "https://github.com/leia-uwu/kate-discord-rpc";
    license = lib.licenses.gpl2;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ Xatra1 ];
  };
})

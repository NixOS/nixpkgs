{
  lib,
  stdenv,
  fetchFromGitHub,
  qt6,
  kdePackages,
  pkg-config,
  cmake,
  ninja,
  python3,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpeditor";
  version = "7.1.1-unstable-2026-04-07";

  src = fetchFromGitHub {
    owner = "cpeditor";
    repo = "cpeditor";
    rev = "912784abcbfb38d70911c45d15a308c339894cec";
    hash = "sha256-udpDsYve1QIQTT75Xk8HHBV1lTTTjauDMyfJKbShgEs=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    qt6.wrapQtAppsHook
    python3
  ];

  buildInputs = [
    qt6.qtbase
    qt6.qttools
    qt6.qt5compat
    kdePackages.syntax-highlighting
  ];

  postPatch = ''
    substituteInPlace src/Core/Runner.cpp --replace-fail "/bin/bash" "${runtimeShell}"
    substituteInPlace dist/linux/cpeditor.desktop --replace-fail 'Exec=/usr/bin/cpeditor' "Exec=cpeditor"
  '';

  meta = {
    description = "IDE specially designed for competitive programming";
    homepage = "https://cpeditor.org";
    license = lib.licenses.gpl3Plus;
    platforms = lib.platforms.linux;
    maintainers = [ lib.maintainers.wineee ];
    mainProgram = "cpeditor";
  };
})

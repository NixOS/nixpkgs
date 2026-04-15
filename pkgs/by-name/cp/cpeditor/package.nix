{
  lib,
  stdenv,
  fetchFromGitHub,
  libsForQt5,
  pkg-config,
  cmake,
  ninja,
  python3,
  runtimeShell,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "cpeditor";
  version = "7.0.2";

  src = fetchFromGitHub {
    owner = "cpeditor";
    repo = "cpeditor";
    tag = finalAttrs.version;
    hash = "sha256-rdGdbMJ3j01RAS/xPZ9zimL0mv8ZW3vYXht6jNFyheI=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    libsForQt5.wrapQtAppsHook
    python3
  ];
  buildInputs = [
    libsForQt5.qtbase
    libsForQt5.qttools
    libsForQt5.syntax-highlighting
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

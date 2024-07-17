{
  lib,
  stdenv,
  fetchFromGitHub,
  pkg-config,
  qtbase,
  qttools,
  wrapQtAppsHook,
  syntax-highlighting,
  cmake,
  ninja,
  python3,
  runtimeShell,
}:

stdenv.mkDerivation rec {
  pname = "cpeditor";
  version = "7.0.1";

  src = fetchFromGitHub {
    owner = "cpeditor";
    repo = "cpeditor";
    rev = version;
    hash = "sha256-t7nn3sO45dOQq5OMWhaseO9XHicQ/1fjukXal5yPMgY";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
    wrapQtAppsHook
    python3
  ];
  buildInputs = [
    qtbase
    qttools
    syntax-highlighting
  ];

  postPatch = ''
    substituteInPlace src/Core/Runner.cpp --replace-fail "/bin/bash" "${runtimeShell}"
  '';

  meta = with lib; {
    description = "An IDE specially designed for competitive programming";
    homepage = "https://cpeditor.org";
    license = licenses.gpl3Plus;
    platforms = platforms.linux;
    maintainers = with maintainers; [ rewine ];
    mainProgram = "cpeditor";
  };
}

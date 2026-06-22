{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  kdePackages,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "kate-code";
  version = "0-unstable-2026-03-07";

  src = fetchFromGitHub {
    owner = "undefinedopcode";
    repo = "kate-code";
    rev = "e422f681e205d24ff69d75acf28fad2f7c3d6a9a";
    hash = "sha256-pxQN47GrqRpGjS2TPCtWmjCMqhJ3qlODuEln17aLkvA=";
  };

  nativeBuildInputs = [
    cmake
    kdePackages.wrapQtAppsHook
  ];

  buildInputs = [
    kdePackages.ktexteditor
    kdePackages.ki18n
    kdePackages.kcoreaddons
    kdePackages.qtwebengine
    kdePackages.kpty
    kdePackages.kxmlgui
  ];

  meta = {
    description = "A Claude Code plugin for the Kate Editor leveraging Zed Industries claude-code-acp";
    homepage = "https://github.com/undefinedopcode/kate-code";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pasqui23 ];
    mainProgram = "kate-code";
    platforms = lib.platforms.all;
  };
})

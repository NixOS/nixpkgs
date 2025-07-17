{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  electron,
  nodejs_20,
  nodePackages,
  makeDesktopItem,
  copyDesktopItems,
}:
buildNpmPackage {
  pname = "sieve-editor-gui";
  version = "0.6.1-unstable-2025-03-12";
  nodejs = nodejs_20;

  src = fetchFromGitHub {
    owner = "thsmi";
    repo = "sieve";
    rev = "4bcefba15314177521a45a833e53969b50f4351e";
    hash = "sha256-jR3+YaVQ+Yd2Xm40SzQNvwWMPe0mJ6bhT96hlUz3/qU=";
  };

  npmDepsHash = "sha256-w2i7XsTx3hlsh/JbvShaxvDyFGcBpL66lMy7KL2tnzM=";

  nativeBuildInputs = [
    electron
    copyDesktopItems
    nodePackages.gulp
  ];

  dontNpmBuild = true;

  buildPhase = ''
    gulp -LLLL app:package
  '';

  installPhase = ''
    runHook preInstall
    mv build/ $out
    runHook postInstall
  '';

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
  };

  desktopItems = [
    (makeDesktopItem {
      name = "sieve-editor-gui";
      exec = "sieve-editor-gui";
      desktopName = "Sieve Editor";
      icon = "sieve-editor-gui";
      categories = [ "Utility" ];
    })
  ];

  postInstall = ''
    makeWrapper ${lib.getExe electron} $out/bin/sieve-editor-gui \
      --add-flags $out/electron/resources/main_esm.js
  '';

  meta = {
    description = "Activate, edit, delete and add Sieve scripts with a convenient interface";
    homepage = "https://github.com/thsmi/sieve";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ Silver-Golden ];
    platforms = lib.platforms.linux;
    mainProgram = "sieve-editor-gui";
  };
}

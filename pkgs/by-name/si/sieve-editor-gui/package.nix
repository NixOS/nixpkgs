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
buildNpmPackage rec {
  pname = "sieve-editor-gui";
  version = "0.6.1-unstable-2024-01-06";
  nodejs = nodejs_20;

  src = fetchFromGitHub {
    owner = "thsmi";
    repo = "sieve";
    rev = "5879679ed8d16a34af760ee56bfec16a1a322b4e";
    hash = "sha256-wl6dwKoGan+DrpXk2p1fD/QN/C2qT4h/g3N73gF8sOI=";
  };

  npmDepsHash = "sha256-a2I9csxFZJekG1uCOHqdRaLLi5v/BLTz4SU+uBd855A=";

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

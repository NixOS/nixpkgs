{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  makeBinaryWrapper,
  electron,
  makeDesktopItem,
  copyDesktopItems,
  nix-update-script,
}:
buildNpmPackage (finalAttrs: {
  pname = "sabaki";
  version = "0.60.2";

  src = fetchFromGitHub {
    owner = "SabakiHQ";
    repo = "Sabaki";
    tag = "v${finalAttrs.version}";
    hash = "sha256-DoP5KZiaf+HYwbmg/im5UawkVwPg1rTVrX3ox5GZc9s=";
  };

  __structuredAttrs = true;

  npmDepsHash = "sha256-KalPH3nGccAnLMGm+mNEmQEt/ucszbYdBoE0VWJqlEk=";

  nativeBuildInputs = [
    makeBinaryWrapper
    copyDesktopItems
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  buildPhase = ''
    runHook preBuild

    npm run bundle

    # electron dist needs to be writable for electron fuses
    cp -r '${electron.dist}' electron-dist
    chmod -R u+w electron-dist

    ./node_modules/.bin/electron-builder \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion='${electron.version}'

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/sabaki
    cp dist/*-unpacked/resources/app.asar $out/share/sabaki/
    install -Dm644 logo.png $out/share/icons/hicolor/512x512/apps/sabaki.png

    makeWrapper '${lib.getExe electron}' "$out/bin/sabaki" \
      --add-flags "$out/share/sabaki/app.asar" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "sabaki";
      desktopName = "Sabaki";
      comment = "Go/Baduk/Weiqi board and SGF editor";
      exec = "sabaki %U";
      icon = "sabaki";
      categories = [
        "Game"
        "BoardGame"
      ];
      mimeTypes = [ "application/x-go-sgf" ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "An elegant Go board and SGF editor for a more civilized age";
    homepage = "https://github.com/SabakiHQ/Sabaki";
    changelog = "https://github.com/SabakiHQ/Sabaki/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ oati ];
    mainProgram = "sabaki";
  };
})

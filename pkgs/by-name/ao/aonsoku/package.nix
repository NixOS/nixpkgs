{
  lib,
  stdenv,
  fetchFromGitHub,
  nodejs,
  pnpm_9,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  electron,
  nix-update-script,
  makeDesktopItem,
  copyDesktopItems,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "aonsoku";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "victoralvesf";
    repo = "aonsoku";
    tag = "v${finalAttrs.version}";
    hash = "sha256-jpBO5MqOc18KGncpOWB/3IjCgkWb2zFfNxTpkcayZwo=";
  };

  patches = [
    ./remove_updater.patch
    ./fix_appid.patch
  ];

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm_9;
    fetcherVersion = 3;
    hash = "sha256-B5bEAj6Ii/c7ZZobQmc8nHFbpBX9n/eYwRZ7lsLs3fk=";
  };

  nativeBuildInputs = [
    nodejs
    pnpm_9
    pnpmConfigHook
    makeWrapper
    electron
    copyDesktopItems
  ];

  buildInputs = [ finalAttrs.pnpmDeps ];

  desktopItems = [
    (makeDesktopItem {
      name = "aonsoku";
      desktopName = "Aonsoku";
      comment = "Modern desktop client for Navidrome/Subsonic servers";
      exec = "Aonsoku";
      icon = "aonsoku";
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
        "Player"
      ];
      startupWMClass = "Aonsoku";
    })
  ];

  preConfigure = ''
    export ELECTRON_SKIP_BINARY_DOWNLOAD=1
  '';

  buildPhase = ''
    runHook preBuild
    pnpm run electron:build
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/aonsoku/out
    cp -r out/* $out/lib/aonsoku/out/

    mkdir -p $out/lib/aonsoku/out/main/resources
    cp -r resources/* $out/lib/aonsoku/out/main/resources/

    cp -r node_modules $out/lib/aonsoku/

    mkdir -p $out/bin
    makeWrapper ${electron}/bin/electron $out/bin/Aonsoku \
      --add-flags $out/lib/aonsoku/out/main/index.js \
      --set ELECTRON_IS_DEV 0

    mkdir -p $out/share/icons/hicolor/512x512/apps
    cp resources/icons/icon.png \
      $out/share/icons/hicolor/512x512/apps/aonsoku.png

    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Modern desktop client for Navidrome/Subsonic servers";
    homepage = "https://github.com/victoralvesf/aonsoku";
    changelog = "https://github.com/victoralvesf/aonsoku/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      genga898
    ];
    mainProgram = "Aonsoku";
  };
})

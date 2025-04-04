{
  autoPatchelfHook,
  callPackage,
  copyDesktopItems,
  electron,
  fetchFromGitHub,
  fetchNpmDeps,
  lib,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
  stdenv,
  buildNpmPackage,
  npmHooks,
  nodejs,
}:

buildNpmPackage rec {
  pname = "bs-manager";
  version = "1.5.2-unstable-2025-03-30";

  src = fetchFromGitHub {
    owner = "Zagrios";
    repo = "bs-manager";
    rev = "273d9532a26b3e15e525bd9b5fb0ca584c77685b";
    hash = "sha256-Bia1apcgdmJmE8XCd+fslQqvT//RL2hj899tXp9kdP4=";
  };

  postPatch = ''
    # don't search for resource is electron's resource directory, but our own
    substituteInPlace src/main/services/utils.service.ts \
      --replace-fail "process.resourcesPath" "'$out/share/bs-manager/resources'"

    # replace vendored DepotDownloader with our own
    rm assets/scripts/DepotDownloader
    ln -s ${passthru.depotdownloader}/bin/DepotDownloader assets/scripts/DepotDownloader
  '';

  npmDepsHash = "sha256-1hW3Pl31h3OKyZVRrgLzMgaHBEG9jfWBcjT9MBfExbc=";

  makeCacheWritable = true;

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  npmRebuildFlags = [ "--ignore-scripts" ];

  nativeBuildInputs = [
    autoPatchelfHook # for some prebuilt node deps: query-process @resvg/resvg-js
    copyDesktopItems
    makeWrapper
  ];

  buildInputs = [
    stdenv.cc.cc
  ];

  preBuild = ''
    pushd release/app
    cp -r ${passthru.extraNodeModules}/node_modules node_modules
    chmod -R u+w node_modules
    npm run postinstall
    popd
  '';

  postBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
      --dir \
      --config=electron-builder.config.js \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version}
  '';

  installPhase = ''
    runHook preInstall

    for icon in build/icons/png/*.png; do
      install -Dm644 $icon $out/share/icons/hicolor/$(basename $icon .png)/apps/bs-manager.png
    done

    mkdir -p $out/share/bs-manager
    cp -r release/build/*-unpacked/{locales,resources{,.pak}} $out/share/bs-manager

    makeWrapper ${lib.getExe electron} $out/bin/bs-manager \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags $out/share/bs-manager/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      desktopName = "BSManager";
      name = "BSManager";
      exec = "bs-manager";
      terminal = false;
      type = "Application";
      icon = "bs-manager";
      mimeTypes = [
        "x-scheme-handler/bsmanager"
        "x-scheme-handler/beatsaver"
        "x-scheme-handler/bsplaylist"
        "x-scheme-handler/modelsaber"
        "x-scheme-handler/web+bsmap"
      ];
      categories = [
        "Utility"
        "Game"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { };

  passthru.extraNodeModules = stdenv.mkDerivation rec {
    name = "bs-manager-${version}-extra-node-modules";

    inherit src;
    sourceRoot = "${src.name}/release/app";

    npmFlags = [ "--ignore-scripts" ];

    nativeBuildInputs = [
      npmHooks.npmConfigHook
      nodejs
    ];

    npmDeps = fetchNpmDeps {
      name = "bs-manager-${version}-extra-npm-deps";
      inherit src sourceRoot;
      hash = "sha256-5LZnifmWZ8IF92c3QimLzqJtggBpeWYBk8SU6LnISsM=";
    };

    installPhase = ''
      mkdir -p $out
      cp -r node_modules $out/node_modules
    '';
  };

  passthru.depotdownloader = callPackage ./depotdownloader.nix { };

  meta = {
    changelog = "https://github.com/Zagrios/bs-manager/blob/${src.rev}/CHANGELOG.md";
    description = "Your Beat Saber Assistant";
    homepage = "https://github.com/Zagrios/bs-manager";
    license = lib.licenses.gpl3Only;
    mainProgram = "bs-manager";
    maintainers = with lib.maintainers; [
      mistyttm
      Scrumplex
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode # prebuilt node deps
    ];
  };
}

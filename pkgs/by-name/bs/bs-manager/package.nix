{
  lib,
  stdenv,
  callPackage,
  nix-update-script,

  buildNpmPackage,
  fetchNpmDeps,
  fetchFromGitHub,
  makeDesktopItem,

  autoPatchelfHook,
  copyDesktopItems,
  makeWrapper,

  electron,
  steam-run-free,
}:

buildNpmPackage (finalAttrs: {
  pname = "bs-manager";
  version = "1.5.4";

  src = fetchFromGitHub {
    owner = "Zagrios";
    repo = "bs-manager";
    tag = "v${finalAttrs.version}";
    hash = "sha256-YitQjhnadQrpdBOV2CUedRNm/RW7/rpXtS9PJTa9kUU=";
  };

  postPatch = ''
    # don't search for resources in electron's resource directory, but our own
    substituteInPlace src/main/services/utils.service.ts \
      --replace-fail "process.resourcesPath" "'$out/share/bs-manager/resources'"

    # replace vendored DepotDownloader with our own
    rm assets/scripts/DepotDownloader
    ln -s ${finalAttrs.passthru.depotdownloader}/bin/DepotDownloader assets/scripts/DepotDownloader
  '';

  npmDepsHash = "sha256-3NMqYD7S4wYjwYuGJOmq2/C82qtG1mImsR4crjFLe30=";

  extraNpmDeps = fetchNpmDeps {
    name = "bs-manager-${finalAttrs.version}-extra-npm-deps";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/release/app";
    hash = "sha256-UWsxty1kfxMr5fybtykrN2G+yiQ9dw/bbMwfcVLJgp4=";
  };

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

    rm -r "$npm_config_cache"
    npmDeps="$extraNpmDeps" npmConfigHook
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
      --prefix PATH : ${lib.makeBinPath [ steam-run-free ]} \
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

  passthru = {
    updateScript = nix-update-script { };
    depotdownloader = callPackage ./depotdownloader { };
  };

  meta = {
    changelog = "https://github.com/Zagrios/bs-manager/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    description = "Your Beat Saber Assistant";
    homepage = "https://github.com/Zagrios/bs-manager";
    license = lib.licenses.gpl3Only;
    mainProgram = "bs-manager";
    maintainers = with lib.maintainers; [
      mistyttm
      Scrumplex
      ImSapphire
      tomasajt
    ];
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      binaryNativeCode # prebuilt node deps
    ];
  };
})

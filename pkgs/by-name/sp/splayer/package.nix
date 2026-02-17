{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  electron,
  rustPlatform,
  cargo,
  rustc,
  python3,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  removeReferencesTo,
}:
stdenv.mkDerivation (finalAttrs: {
  pname = "splayer";
  version = "3.0.0-beta.9";

  src = fetchFromGitHub {
    owner = "imsyy";
    repo = "SPlayer";
    tag = "v${finalAttrs.version}";
    fetchSubmodules = false;
    hash = "sha256-+9F4ckATxRE+/PhMi5c1GVDq5V9QMOogCD9uT6QkREM=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_10;
    fetcherVersion = 2;
    hash = "sha256-tAOtrxQasIQ1IS2jKdcX4KEM5p3zhshqw8phzsj667Q=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-QKk1coOuZNaqKgvbBgorvOotHmTJ+YXTHBfyhF0L37E=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm_10
    nodejs
    rustPlatform.cargoSetupHook
    cargo
    rustc
    python3
    makeWrapper
    copyDesktopItems
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postConfigure = ''
    cp .env.example .env
  '';

  postPatch = ''
    # Workaround for https://github.com/electron/electron/issues/31121
    substituteInPlace electron/main/utils/native-loader.ts \
      --replace-fail 'process.resourcesPath' "'$out/share/splayer/resources'"
  '';

  buildPhase = ''
    runHook preBuild

    # After the pnpm configure, we need to build the binaries of all instances
    # of better-sqlite3. It has a native part that it wants to build using a
    # script which is disallowed.
    # What's more, we need to use headers from electron to avoid ABI mismatches.
    # Adapted from mkYarnModules.
    for f in $(find . -path '*/node_modules/better-sqlite3' -type d); do
      (cd "$f" && (
      npm run build-release --offline --nodedir="${electron.headers}"
      find build -type f -exec \
        ${lib.getExe removeReferencesTo} \
        -t "${electron.headers}" {} \;
      ))
    done
    rm -rf build/Release/{.deps,obj,obj.target,test_extension.node}

    pnpm build

    npm exec electron-builder -- \
        --dir \
        --config electron-builder.config.ts \
        -c.electronDist=${electron.dist} \
        -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p "$out/share/splayer"
    cp -Pr --no-preserve=ownership dist/*-unpacked/{locales,resources{,.pak}} $out/share/splayer

    _icon_sizes=(16x16 32x32 96x96 192x192 256x256 512x512)
    for _icons in "''${_icon_sizes[@]}";do
      install -D public/icons/favicon-$_icons.png $out/share/icons/hicolor/$_icons/apps/splayer.png
    done

    makeWrapper '${lib.getExe electron}' "$out/bin/splayer" \
      --add-flags $out/share/splayer/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "splayer";
      desktopName = "SPlayer";
      exec = "splayer %U";
      terminal = false;
      type = "Application";
      icon = "splayer";
      startupWMClass = "SPlayer";
      comment = "A minimalist music player";
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
      ];
      mimeTypes = [ "x-scheme-handler/orpheus" ];
      extraConfig.X-KDE-Protocols = "orpheus";
    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Simple Netease Cloud Music player";
    homepage = "https://github.com/imsyy/SPlayer";
    changelog = "https://github.com/imsyy/SPlayer/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    mainProgram = "splayer";
    platforms = lib.platforms.linux;
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      # public/wasm/ffmpeg.wasm
      # source: https://github.com/apoint123/ffmpeg-audio-player
      # native/ferrous-opencc-wasm/pkg/ferrous_opencc_wasm_bg.wasm
      # source: native/ferrous-opencc-wasm
      binaryBytecode
    ];
  };
})

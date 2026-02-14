{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchurl,
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  nodejs_22,
  asar,
  exiftool,
  p7zip,
  patchelf,
  electron,
  makeWrapper,
  commandLineArgs ? "",
  copyDesktopItems,
  makeDesktopItem,
  libva,
  writableTmpDirAsHomeHook,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "bilibili";
  version = "1.17.5-3";

  src = fetchFromGitHub {
    owner = "msojocs";
    repo = "bilibili-linux";
    tag = "v${finalAttrs.version}";
    hash = "sha256-bmvpJqoAJSizRCI9WMMHfnldLo0nyhu/TeOKhfs7wPM=";
  };

  bilibiliInstaller = fetchurl {
    url = "https://web.archive.org/web/20260214125654/https://dl.hdslb.com/mobile/fixed/bili_win/bili_win-install.exe";
    hash = "sha256-m0SKH4PPAb/Fi1jcc6pEHMmVBesNQidD4H4pD4jaDnE=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 3;
    hash = "sha256-a24NJtnZhDxfJ2eNxbpFYsKw84KMrRjKdtZdLUZP8uk=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm
    nodejs_22
    asar
    exiftool
    p7zip
    patchelf
    makeWrapper
    copyDesktopItems
    writableTmpDirAsHomeHook
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    NPM_CONFIG_MANAGE_PACKAGE_MANAGER_VERSIONS = "false";
    CI = "true";
  };

  postPatch = ''
    # Keep builds hermetic; pnpm otherwise tries to self-manage the configured version.
    substituteInPlace package.json \
      --replace-fail '"packageManager": "pnpm@10.2.1+sha512.398035c7bd696d0ba0b10a688ed558285329d27ea994804a52bad9167d8e3a72bcb993f9699585d3ca25779ac64949ef422757a6c31102c12ab932e5cbe5cc92"' '"_packageManager": "pnpm@10.2.1"'
  '';

  # Upstream build flow reference:
  # https://github.com/msojocs/bilibili-linux/tree/master/tools
  # We mirror the logic from setup-bilibili + update-bilibili + fix-other.sh + extension.sh
  # here instead of invoking them directly.
  # Reason: those scripts call `wget` at build time
  buildPhase = ''
    runHook preBuild

    # sass-embedded ships a prebuilt ELF with a FHS interpreter path; patch it for Nix.
    for dart_bin in $(find node_modules -type f -path '*/dart-sass/src/dart'); do
      patchelf --set-interpreter ${stdenv.cc.bintools.dynamicLinker} "$dart_bin"
    done

    pnpm run build

    mkdir -p tmp/bili

    BILIBILI_VERSION="$(exiftool -S -ProductVersionNumber "${finalAttrs.bilibiliInstaller}" | sed 's/.*: //')"
    CONF_VERSION="$(cat conf/bilibili_version)"
    if [ "$BILIBILI_VERSION" != "$CONF_VERSION" ]; then
      echo "bilibili installer version mismatch: $BILIBILI_VERSION != $CONF_VERSION" >&2
      exit 1
    fi

    7z x -y "${finalAttrs.bilibiliInstaller}" -otmp/bili '$PLUGINSDIR/app-64.7z'
    7z x -y tmp/bili/\$PLUGINSDIR/app-64.7z -otmp/bili resources

    res_dir="$PWD/tmp/bili/resources"

    asar extract "$res_dir/app.asar" "$res_dir/app"

    node tools/app-decrypt.js "$res_dir/app/main/.biliapp" "$res_dir/app/main/app.orgi.js"
    node tools/js-decode.js "$res_dir/app/main/app.orgi.js" "$res_dir/app/main/app.js"
    node tools/bridge-decode.js "$res_dir/app/main/assets/bili-bridge.js" "$res_dir/app/main/assets/bili-bridge.js"

    sed -i 's#if (!jy)#if(false\&\&!jy)#' "$res_dir/app/main/app.js"
    sed -i 's#// noinspection SuspiciousTypeOfGuard#runtimeOptions.platform="win32";// noinspection SuspiciousTypeOfGuard#' "$res_dir/app/node_modules/electron-updater/out/providerFactory.js"
    sed -i 's#process.resourcesPath#path.dirname(this.app.getAppPath())#' "$res_dir/app/node_modules/electron-updater/out/ElectronAppAdapter.js"

    cat res/scripts/inject-bridge.js "$res_dir/app/main/assets/bili-inject.js" > "$res_dir/app/main/assets/temp.js"
    mv "$res_dir/app/main/assets/temp.js" "$res_dir/app/main/assets/bili-inject.js"

    cat res/scripts/inject-core.js "$res_dir/app/render/assets/lib/core.js" > "$res_dir/app/render/assets/lib/temp.js"
    mv "$res_dir/app/render/assets/lib/temp.js" "$res_dir/app/render/assets/lib/core.js"

    cat res/scripts/inject-bridge.js "$res_dir/app/main/assets/bili-preload.js" > "$res_dir/app/main/assets/temp.js"
    mv "$res_dir/app/main/assets/temp.js" "$res_dir/app/main/assets/bili-preload.js"

    asar pack "$res_dir/app" "$res_dir/app.asar"
    rm -rf "$res_dir/app"

    mkdir -p app/extensions
    cp -r dist/extension app/extensions/bilibili
    cp res/scripts/transcribe.py app/transcribe.py

    asar extract "$res_dir/app.asar" "$res_dir/app"
    cp dist/inject/index.js "$res_dir/app/index.js"
    asar pack "$res_dir/app" "$res_dir/app.asar"
    rm -rf "$res_dir/app"

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    install -Dm644 res/icons/256x256.png \
      $out/share/icons/hicolor/256x256/apps/bilibili.png

    mkdir -p $out/share/bilibili
    cp "$PWD/tmp/bili/resources/app.asar" $out/share/bilibili/app.asar
    cp -r app/extensions $out/share/bilibili/extensions
    cp app/transcribe.py $out/share/bilibili/transcribe.py

    makeWrapper ${lib.getExe electron} $out/bin/bilibili \
      --argv0 "bilibili" \
      --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ libva ]} \
      --add-flags "$out/share/bilibili/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --add-flags "--enable-features=AcceleratedVideoDecodeLinuxGL,AcceleratedVideoDecodeLinuxZeroCopyGL" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "bilibili";
      desktopName = "Bilibili";
      exec = "bilibili %U";
      icon = "bilibili";
      categories = [
        "AudioVideo"
        "Video"
      ];
    })
  ];

  meta = {
    description = "Electron-based bilibili desktop client";
    homepage = "https://github.com/msojocs/bilibili-linux";
    license = with lib.licenses; [
      unfree
      mit
    ];
    maintainers = with lib.maintainers; [
      jedsek
      kashw2
      bot-wxt1221
    ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode
    ];
    mainProgram = "bilibili";
  };
})

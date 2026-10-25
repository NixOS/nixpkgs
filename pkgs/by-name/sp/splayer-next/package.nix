{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  electron_44,
  rustPlatform,
  cargo,
  rustc,
  python3,
  pkg-config,
  openssl,
  alsa-lib,
  libpulseaudio,
  pipewire,
  dbus,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  removeReferencesTo,
}:
let
  electron = electron_44;
  pnpm = pnpm_12;
  shareDir = "$out/share/SPlayer-Next";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "splayer-next";
  version = "1.2.0";

  src = fetchFromGitHub {
    owner = "SPlayer-Dev";
    repo = "SPlayer-Next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0t16eXRb0B1We6m8Ks1+uPgD1mW19HztChEgq1oap1Q=";
    leaveDotGit = true;
    postFetch = ''
      cd "$out"
      git rev-parse HEAD > $out/COMMIT
      git log -1 --format=%cI > $out/SOURCE_DATE_EPOCH
      find "$out" -name .git -print0 | xargs -0 rm -rf
    '';
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      prePatch
      ;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-LA1B96BjvaTHKFI1IxkNfnFAy2D9DgmRjKAegWkJtIw=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-9doP83tZlKM8Hsu+NHYOLLWq1RWFS+IGB2oOXwA4d2g=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm
    nodejs
    rustPlatform.cargoSetupHook
    rustPlatform.bindgenHook
    cargo
    rustc
    python3
    makeWrapper
    copyDesktopItems
    pkg-config
    removeReferencesTo
  ];

  buildInputs = [
    openssl
    alsa-lib
    libpulseaudio
    pipewire
    dbus
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  strictDeps = true;
  __structuredAttrs = true;

  prePatch = ''
    rm .npmrc
  '';

  postPatch = ''
    # Workaround for https://github.com/electron/electron/issues/31121
    substituteInPlace electron/main/utils/nativeLoader.ts electron/main/services/recognition/fingerprint.ts \
      --replace-fail 'process.resourcesPath' "'${shareDir}/resources'"

    substituteInPlace electron.vite.config.ts \
      --replace-fail 'import { execSync } from "child_process";' 'import { readFileSync } from "fs";' \
      --replace-fail 'execSync("git rev-parse HEAD").toString()' 'readFileSync("COMMIT", "utf8")' \
      --replace-fail 'execSync("git log -1 --format=%cI").toString()' 'readFileSync("SOURCE_DATE_EPOCH", "utf8")'
  '';

  buildPhase = ''
    runHook preBuild

    # After the pnpm configure, we need to build the binaries of all instances
    # of better-sqlite3. It has a native part that it wants to build using a
    # script which is disallowed.
    # What's more, we need to use headers from electron to avoid ABI mismatches.
    for f in $(find . -path '*/node_modules/better-sqlite3' -type d); do
      (cd "$f" && (
        rm -rf prebuilds
        npm run build-release --offline --nodedir="${electron.headers}"
        rm -rf build/Release/{.deps,obj,obj.target,test_extension.node}
        find build -type f -exec \
          remove-references-to -t "${electron.headers}" {} \;
        )
      )
    done

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

    # remove references to nodejs
    find dist/*-unpacked/{locales,resources{,.pak}} -type f -exec remove-references-to -t ${nodejs} '{}' \;

    mkdir -p "${shareDir}"
    cp -Pr --no-preserve=ownership dist/*-unpacked/{locales,resources{,.pak}} "${shareDir}"

    _icon_sizes=(16x16 32x32 96x96 192x192 256x256 512x512)
    for _icons in "''${_icon_sizes[@]}";do
      install -D public/icons/favicon-$_icons.png $out/share/icons/hicolor/$_icons/apps/SPlayer-Next.png
    done

    makeWrapper '${lib.getExe electron}' "$out/bin/SPlayer-Next" \
      --add-flags "${shareDir}/resources/app.asar" \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --set-default ELECTRON_IS_DEV 0 \
      --inherit-argv0

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "top.imsyy.splayer_next";
      desktopName = "SPlayer-Next";
      exec = "SPlayer-Next %U";
      terminal = false;
      type = "Application";
      icon = "SPlayer-Next";
      startupWMClass = "top.imsyy.splayer_next";
      comment = "Cross-platform desktop music player with rich lyric support and wide audio format compatibility";
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
    description = "Cross-platform desktop music player with rich lyric support and wide audio format compatibility";
    homepage = "https://github.com/SPlayer-Dev/SPlayer-Next";
    changelog = "https://github.com/SPlayer-Dev/SPlayer-Next/releases/tag/v${finalAttrs.version}";
    license = with lib.licenses; [
      agpl3Only
      gpl3Only # ffmpeg_audio_sys
      lgpl21Plus # bundled FFmpeg
    ];
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryBytecode # resources/afp/afp.wasm.mjs
    ];
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    mainProgram = "SPlayer-Next";
    platforms = lib.platforms.linux;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs,
  electron_43,
  rustPlatform,
  cargo,
  rustc,
  python3,
  pkg-config,
  openssl,
  ffmpeg-headless,
  alsa-lib,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
  removeReferencesTo,
}:
let
  electron = electron_43;
  pnpm = pnpm_10;
  shareDir = "$out/share/SPlayer-Next";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "splayer-next";
  version = "1.0.0";

  src = fetchFromGitHub {
    owner = "SPlayer-Dev";
    repo = "SPlayer-Next";
    tag = "v${finalAttrs.version}";
    hash = "sha256-D2Ja/ZF5hKRVy/O33mCsl0iulYUqP/qRiQLjX0tl0dM=";
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
    hash = "sha256-zCWX8N4VGZQirHjbseExOVdk4cjFUxJnjYwHFYbKWjM=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    hash = "sha256-iZtUPQ3yUomUNf6j+gV0HxcwsvjBPOVqwzwUvsP0CCY=";
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
    ffmpeg-headless
    alsa-lib
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    FFMPEG_MODE = "system";
  };

  strictDeps = true;
  __structuredAttrs = true;

  prePatch = ''
    rm .npmrc
  '';

  postPatch = ''
    # Workaround for https://github.com/electron/electron/issues/31121
    substituteInPlace electron/main/utils/nativeLoader.ts \
      --replace-fail 'process.resourcesPath' "'${shareDir}/resources'"

    sed -i '/^[[:space:]]*\.atleast_version/d' "$cargoDepsCopy"/{.,*}/ffmpeg_audio_sys-*/build.rs
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
      --prefix LD_PRELOAD : "${ffmpeg-headless.lib}/lib/libavformat.so" \
      --prefix LD_PRELOAD : "${ffmpeg-headless.lib}/lib/libavcodec.so" \
      --prefix LD_PRELOAD : "${ffmpeg-headless.lib}/lib/libavutil.so" \
      --prefix LD_PRELOAD : "${ffmpeg-headless.lib}/lib/libswresample.so" \
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
    license = lib.licenses.agpl3Only;
    maintainers = with lib.maintainers; [ ccicnce113424 ];
    mainProgram = "SPlayer-Next";
    platforms = lib.platforms.linux;
  };
})

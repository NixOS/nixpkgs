{
  lib,
  stdenv,
  fetchFromGitHub,
  pnpm_12,
  fetchPnpmDeps,
  pnpmConfigHook,
  nodejs_24,
  electron_44,
  rustPlatform,
  cargo,
  rustc,
  python3,
  pkg-config,
  openssl,
  ffmpeg-headless,
  alsa-lib,
  libpulseaudio,
  pipewire,
  dbus,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  removeReferencesTo,
}:
let
  electron = electron_44;
  pnpm = pnpm_12;
  shareDir = "$out/share/splayer-z";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "splayer-z";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "MasterZack69";
    repo = "SPlayer-Z";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Ly9DyeSbNnqpFh2eJnaOazaX3aiM/MOrfhkhJ0Uottc=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      prePatch
      ;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-2O6XaRgyQxWD7Y9JDEtYLCMxGvdbc3KAFM7pgst2w6I=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-7Q2G72liNTuiai6q9HYuZKJwwglmXFUcGfHKTwkUZ3c=";
  };

  nativeBuildInputs = [
    pnpmConfigHook
    pnpm
    nodejs_24
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
    libpulseaudio
    pipewire
    dbus
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    FFMPEG_MODE = "system";
    # Identity of the v1.1.1 source, without retaining a .git directory.
    SPLAYER_COMMIT = "e00c595767dec7f6f49ed518a7b1a4d5bfb1c65c";
    SOURCE_DATE_EPOCH = "1793001866";
  };

  strictDeps = true;
  __structuredAttrs = true;

  prePatch = ''
    # Use Nix's pnpm instead of downloading the packageManager-pinned binary.
    cat > .npmrc <<'NPMRC'
    manage-package-manager-versions=false
    package-manager-strict-version=false
    NPMRC
  '';

  postPatch = ''
    # Workaround for https://github.com/electron/electron/issues/31121.
    substituteInPlace electron/main/utils/nativeLoader.ts \
      --replace-fail 'process.resourcesPath' "'${shareDir}/resources'"

    sed -i '/^[[:space:]]*\.atleast_version/d' \
      "$cargoDepsCopy"/{.,*}/ffmpeg_audio_sys-*/build.rs
  '';

  buildPhase = ''
    runHook preBuild

    # Rebuild SQLite against the same Electron ABI used by the wrapper.
    while IFS= read -r -d "" sqliteDir; do
      (
        cd "$sqliteDir"
        rm -rf prebuilds
        npm run build-release --offline -- --nodedir="${electron.headers}"
        rm -rf build/Release/{.deps,obj,obj.target,test_extension.node}
        find build -type f -exec \
          remove-references-to -t "${electron.headers}" {} \;
      )
    done < <(find . -path '*/node_modules/better-sqlite3' -type d -print0)

    pnpm build

    pnpm exec electron-builder \
      --dir \
      --publish never \
      --config electron-builder.config.ts \
      -c.electronDist=${electron.dist} \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    find dist/*-unpacked/{locales,resources{,.pak}} -type f -exec \
      remove-references-to -t ${nodejs_24} {} \;

    mkdir -p "${shareDir}"
    cp -Pr --no-preserve=ownership \
      dist/*-unpacked/{locales,resources{,.pak}} "${shareDir}"
    install -Dm644 LICENSE "$out/share/licenses/splayer-z/LICENSE"

    for size in 16x16 32x32 96x96 192x192 256x256 512x512; do
      install -Dm644 "public/icons/favicon-$size.png" \
        "$out/share/icons/hicolor/$size/apps/splayer-z.png"
    done

    makeWrapper '${lib.getExe electron}' "$out/bin/splayer-z" \
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
      name = "io.github.MasterZack69.SPlayerZ";
      desktopName = "SPlayer-Z";
      exec = "splayer-z %U";
      terminal = false;
      type = "Application";
      icon = "splayer-z";
      startupWMClass = "io.github.MasterZack69.SPlayerZ";
      comment = "Linux music player with local lyrics and self-hosted media libraries";
      categories = [
        "AudioVideo"
        "Audio"
        "Music"
      ];
      mimeTypes = [ "x-scheme-handler/orpheus" ];
      extraConfig.X-KDE-Protocols = "orpheus";
    })
  ];

  meta = {
    description = "Linux music player with local lyrics and self-hosted media libraries";
    homepage = "https://github.com/MasterZack69/SPlayer-Z";
    changelog = "https://github.com/MasterZack69/SPlayer-Z/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.agpl3Only;
    mainProgram = "splayer-z";
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
    ];
    maintainers = [ lib.maintainers.MasterZack69 ];
  };
})

{
  lib,
  fetchFromGitHub,
  substitute,
  stdenv,
  yarn-berry_4,
  nodejs_24,
  electron_45,
  makeWrapper,
  ffmpeg-headless,
  copyDesktopItems,
  makeDesktopItem,
  imagemagick,
  darwin,
}:
let
  yarn-berry = yarn-berry_4;
  nodejs = nodejs_24;
  electron = electron_45;
  resourcesDir =
    if stdenv.hostPlatform.isDarwin then
      "Applications/LosslessCut.app/Contents/Resources"
    else
      "share/losslesscut";
in
stdenv.mkDerivation (finalAttrs: {
  pname = "losslesscut";
  version = "3.70.1-unstable-2026-10-24";

  src = fetchFromGitHub {
    owner = "mifi";
    repo = "lossless-cut";
    rev = "14b89b425213b447396e3c3cddc2ef2a7d45d61f";
    hash = "sha256-9iYZT3/cQyU7uVHvXdHoM/jNzubZMX4XYkKhAePl6uo=";
  };

  patches = [
    # LosslessCut will retrieve a URL from mifi.no (the author's domain) and directly embed the HTML in the app.
    # This was previously used to show a Ukraine flag, which I don't have strong opinions on.
    # However, this effectively allows arbitrary code execution, which could be IP-gated. I can't allow that.
    # This is also a form of telemetry; a ping every time the application is launched.
    # See https://github.com/mifi/lossless-cut/issues/1055
    ./stub-load-mifi.patch
  ];

  prePatch = ''
    # Catch unreplaced files
    catchUnreplacedFiles() {
      local pattern="$1"
      shift
      local -i status=0
      local unreplacedFiles
      unreplacedFiles=$(grep -r -l "$pattern" "$@") || status="$?"
      case $status in
      0)
        echo "ERROR: Found unreplaced $pattern in files:" >&2
        printf '%s\n' "$unreplacedFiles" >&2
        return 1
        ;;
      1)
        # No unmatched file found. Good.
        ;;
      *)
        # Grep failed
        return "$status"
        ;;
      esac
    }
  '';

  postPatch = ''
    # Disable afterPack during build,
    # as afterPack expects the upstream ffmpeg bundle.
    substituteInPlace package.json \
      --replace-fail '"afterPack": "./script/afterPack.ts",' ""

    # Disable update check by making enableUpdateCheck configuration always false
    # * Changge the configuration access.
    #   * Replace default value.
    #   * Monkey patch the config getter (whose generic return type is `Config[T]`).
    substituteInPlace src/main/configStore.ts \
      --replace-fail "enableUpdateCheck: true," "enableUpdateCheck: false," \
      --replace-fail \
        "return store.get(key);" \
        "return key === 'enableUpdateCheck' ? (false as Config[T]) : store.get(key);"
    # * Change the "File > Settings" UI.
    #   * Make the enableUpdateCheck switch non-interactive and keep it unchecked.
    #   * Change the label to inform users about the option being disabled in Nixpkgs.
    substituteInPlace src/renderer/src/components/Settings.tsx \
      --replace-fail \
        "<KeyCell>{t('Check for updates on startup?')}</KeyCell>" \
        "<KeyCell>{t('Check for updates on startup? (disabled in Nixpkgs)')}</KeyCell>" \
      --replace-fail \
        "<Switch checked={enableUpdateCheck} onCheckedChange={setEnableUpdateCheck} />" \
        "<Switch checked={false} disabled />"

    # Hard-code app.isPackaged as true
    for f in src/main/ffmpeg.ts src/main/i18nCommon.ts src/main/logger.ts; do
      substituteInPlace "$f" \
        --replace-fail app.isPackaged "true"
    done
    catchUnreplacedFiles app.isPackaged --include="*.ts" --include="*.tsx" src

    # Hard-code resources path
    for f in src/main/ffmpeg.ts src/main/i18nCommon.ts; do
      substituteInPlace "$f" \
        --replace-fail process.resourcesPath "'$out/${resourcesDir}/'"
    done
    catchUnreplacedFiles process.resourcesPath --include="*.ts" --include="*.tsx" src
  '';

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_OVERRIDE_DIST_PATH = electron.dist;
    NODE_ENV = "production";
  };

  strictDeps = true;

  nativeBuildInputs = [
    nodejs
    yarn-berry.yarnBerryConfigHook
    yarn-berry
    makeWrapper
    copyDesktopItems
    imagemagick
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    darwin.autoSignDarwinBinariesHook
  ];

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "losslesscut";
      desktopName = "LosslessCut";
      comment = "simple video editor to trim or cut videos";
      exec = "losslesscut";
      icon = "losslesscut";
      mimeTypes = [
        "video/mpeg"
        "video/x-mpeg"
        "video/msvideo"
        "video/quicktime"
        "video/x-anim"
        "video/x-avi"
        "video/x-ms-asf"
        "video/x-ms-wmv"
        "video/x-msvideo"
        "video/x-nsv"
        "video/x-flc"
        "video/x-fli"
        "video/x-flv"
        "video/vnd.rn-realvideo"
        "video/mp4"
        "video/mp4v-es"
        "video/mp2t"
        "application/ogg"
        "application/x-ogg"
        "video/x-ogm+ogg"
        "audio/x-vorbis+ogg"
        "application/x-matroska"
        "audio/x-matroska"
        "video/x-matroska"
        "video/webm"
      ];
      terminal = false;
      categories = [
        "AudioVideo"
        "AudioVideoEditing"
      ];
      keywords = [
        "trim"
        "codec"
        "cut"
        "movie"
        "mpeg"
        "avi"
        "h264"
        "mkv"
        "mp4"
      ];
      startupWMClass = "losslesscut";
    })
  ];

  missingHashes = ./missing-hashes.json;
  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    # hash = "sha256-VtmrYuRBvouzEDrp3CDIT1GWoHkU5dHp8Y93VwMk1oY=";
    hash = "sha256-xsw9AqsOTCGHDNPqt+dspXw7dvBhaKcQY35XZQ0Cmag=";
  };

  postConfigure = ''
    cp -r ${electron.dist} electron-dist
    chmod u+w -R electron-dist
  '';

  buildPhase = ''
    runHook preBuild

    yarn build

    yarn electron-builder \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "-c.mac.identity=null"}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/applications

    cp -a dist/*-unpacked/resources $out/${resourcesDir}
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications

    mv dist/mac*/LosslessCut.app $out/Applications/
  ''
  + ''
    ln -s -t $out/${resourcesDir}/ ${lib.getExe' ffmpeg-headless "ffmpeg"} ${lib.getExe' ffmpeg-headless "ffprobe"}
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    makeWrapper ${lib.getExe electron} $out/bin/losslesscut \
      --add-flags $out/${resourcesDir}/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick src/renderer/src/icon.svg -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/losslesscut.png
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    makeWrapper $out/Applications/LosslessCut.app/Contents/MacOS/LosslessCut $out/bin/losslesscut
  ''
  + ''
    runHook postInstall
  '';

  # Stripping the Electron frameworks breaks them
  stripDebugList = lib.optionals stdenv.hostPlatform.isDarwin [
    "Applications/LosslessCut.app/Contents/MacOS"
  ];

  __structuredAttrs = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Swiss army knife of lossless video/audio editing";
    homepage = "https://losslesscut.app/";
    ${if finalAttrs.src.tag != null then "changelog" else null} =
      "https://github.com/mifi/lossless-cut/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [
      shelvacu
      ShamrockLee
    ];
    mainProgram = "losslesscut";
    sourceProvenance = with lib.sourceTypes; [
      fromSource
      binaryNativeCode # due to npm/yarn deps
    ];
  };
})

{
  lib,
  fetchFromGitHub,
  stdenv,
  yarn-berry_4,
  nodejs_24,
  electron_42,
  makeWrapper,
  ffmpeg-headless,
  copyDesktopItems,
  makeDesktopItem,
  imagemagick,
}:
let
  yarn-berry = yarn-berry_4;
  nodejs = nodejs_24;
  electron = electron_42;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "losslesscut";
  version = "3.69.0";

  src = fetchFromGitHub {
    owner = "mifi";
    repo = "lossless-cut";
    tag = "v${finalAttrs.version}";
    hash = "sha256-VNG23I5o9FjoFbiF6FyOG/g72XrF4FloIyd08zIKQRU=";
  };

  patches = [
    # fixes a few things that try to guess whether it's a dev build
    ./undev.patch
    ./yarn-4.14-support.patch
    ./disable-update-check.patch
    # LosslessCut will retrieve a URL from mifi.no (the author's domain) and directly embed the HTML in the app.
    # This was previously used to show a Ukraine flag, which I don't have strong opinions on.
    # However, this effectively allows arbitrary code execution, which could be IP-gated. I can't allow that.
    # This is also a form of telemetry; a ping every time the application is launched.
    # See https://github.com/mifi/lossless-cut/issues/1055
    ./stub-load-mifi.patch
  ];

  postPatch = ''
    for f in src/main/ffmpeg.ts src/main/i18nCommon.ts; do
      substituteInPlace "$f" \
        --subst-var-by losslesscut_resources_path $out/share/losslesscut
    done
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
  ];

  desktopItems = [
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
    inherit (finalAttrs) src missingHashes patches;
    hash = "sha256-ioTQKZrT0lFnlmjVJL/kS5yP+oCw1GUZx0LWK2BqBq0=";
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
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/bin $out/share/applications

    cp -a dist/*-unpacked/resources $out/share/losslesscut

    ln -s -t $out/share/losslesscut/ ${lib.getExe' ffmpeg-headless "ffmpeg"} ${lib.getExe' ffmpeg-headless "ffprobe"}

    makeWrapper ${lib.getExe electron} $out/bin/losslesscut \
      --set-default ELECTRON_IS_DEV 0 \
      --add-flags $out/share/losslesscut/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}"

    for size in 16 24 32 48 64 128 256 512; do
      mkdir -p $out/share/icons/hicolor/"$size"x"$size"/apps
      magick src/renderer/src/icon.svg -resize "$size"x"$size" $out/share/icons/hicolor/"$size"x"$size"/apps/losslesscut.png
    done

    runHook postInstall
  '';

  __structuredAttrs = true;

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Swiss army knife of lossless video/audio editing";
    homepage = "https://losslesscut.app/";
    changelog = "https://github.com/mifi/lossless-cut/releases/tag/${finalAttrs.src.tag}";
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

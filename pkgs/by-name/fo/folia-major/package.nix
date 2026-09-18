{
  lib,
  stdenvNoCC,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  imagemagick,
  makeWrapper,
  electron,
  ffmpeg_8,
  copyDesktopItems,
  makeDesktopItem,
  nix-update-script,
}:

let
  resourcesDir =
    if stdenvNoCC.hostPlatform.isDarwin then
      "$out/Applications/Folia.app/Contents/Resources"
    else
      "$out/share/folia-major/resources";
in

buildNpmPackage (finalAttrs: {
  pname = "folia-major";
  version = "0.7.4";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chthollyphile";
    repo = "folia-major";
    tag = "v${finalAttrs.version}";
    hash = "sha256-cTnxh+UZ9XTHdH0193sqVaFnNhLU1PMjBlyUHrurYDY=";
  };

  npmDepsHash = "sha256-xlJBQjg3iwd05crLaomlBAF9SAxH4Il9NmU3rYYugYo=";

  nativeBuildInputs = [
    makeWrapper
    copyDesktopItems
  ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_DEV = "false";
    ELECTRON = "true";
  };

  # workaround for https://github.com/electron/electron/issues/31121
  postPatch = ''
    substituteInPlace electron/main.cjs \
      --replace-fail "process.resourcesPath" "'${resourcesDir}'"

    substituteInPlace vite.config.ts \
      --replace-fail "git rev-parse --short HEAD" "echo unknown" \
      --replace-fail "git rev-parse --abbrev-ref HEAD" "echo main"

    cat <<< $(${lib.getExe jq} 'del(.build.beforePack)' ./package.json) > ./package.json
    cat <<< $(${lib.getExe jq} 'del(.build.generateUpdatesFilesForAllChannels)' ./package.json) > ./package.json

    ${lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
      ${lib.getExe imagemagick} build/icon.png build/icon.icns
      cat <<< $(${lib.getExe jq} '.build.mac.icon = "build/icon.icns"' ./package.json) > ./package.json
    ''}
  '';

  buildPhase = ''
    runHook preBuild

    npm run build

    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist
    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.mac.identity=null

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    ${
      if stdenvNoCC.hostPlatform.isDarwin then
        ''
          mkdir -p $out/{Applications,bin}
          cp -r release/mac*/Folia.app $out/Applications
          makeWrapper $out/Applications/Folia.app/Contents/MacOS/Folia $out/bin/folia-major
        ''
      else
        ''
          mkdir -p $out/share/folia-major
          cp -r release/*-unpacked/{locales,resources{,.pak}} $out/share/folia-major/

          install -D build/icon.png $out/share/icons/hicolor/512x512/apps/folia-major.png

          makeWrapper '${lib.getExe electron}' $out/bin/folia-major \
            --add-flags $out/share/folia-major/resources/app.asar \
            --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
            --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
            --set-default ELECTRON_IS_DEV 0 \
            --inherit-argv0
        ''
    }

    mkdir -p ${resourcesDir}/ffmpeg-audio
    ln -s ${lib.getExe' ffmpeg_8 "ffmpeg"} ${resourcesDir}/ffmpeg-audio/ffmpeg

    runHook postInstall
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "folia-major";
      desktopName = "Folia";
      exec = "folia-major";
      terminal = false;
      type = "Application";
      icon = "folia-major";
      startupWMClass = "folia";
      comment = "Lyrics Reimagine";
      categories = [
        "AudioVideo"
        "Player"
      ];
    })
  ];

  passthru.updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };

  meta = {
    description = "Lyrics Reimagine desktop app";
    homepage = "https://folia-site.cielaniska.top/";
    downloadPage = "https://github.com/chthollyphile/folia-major/releases";
    changelog = "https://github.com/chthollyphile/folia-major/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.agpl3Only;
    mainProgram = "folia-major";
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

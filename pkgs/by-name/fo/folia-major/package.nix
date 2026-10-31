{
  lib,
  stdenv,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  imagemagick,
  makeWrapper,
  electron,
  ffmpeg_8,
  nix-update-script,
}:

let
  resourcesDir =
    if stdenv.hostPlatform.isDarwin then
      "$out/Applications/Folia.app/Contents/Resources"
    else
      "$out/share/folia-major/resources";

  inherit (stdenv.hostPlatform.node) arch platform;

  # electron-builder's ${os}-${arch}, used by extraResources in package.json
  platformDir = "${if stdenv.hostPlatform.isDarwin then "mac" else platform}-${arch}";
in
buildNpmPackage (finalAttrs: {
  pname = "folia-major";
  version = "0.7.15";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chthollyphile";
    repo = "folia-major";
    tag = "v${finalAttrs.version}";
    hash = "sha256-TzplbxRUH10bSvV6gnRkaZJfp91TQq21pvN5haTFYfM=";
  };

  npmDepsHash = "sha256-7SXUneDyMmqMzyEI/oXTGVD4FOq1pQf/aSS995fz9oU=";

  nativeBuildInputs = [
    jq
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ imagemagick ];

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    ELECTRON_DEV = "false";
    ELECTRON = "true";
  };

  postPatch = ''
    substituteInPlace vite.config.ts \
      --replace-fail "git rev-parse --short HEAD" "echo unknown" \
      --replace-fail "git rev-parse --abbrev-ref HEAD" "echo main"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # workaround for https://github.com/electron/electron/issues/31121
    substituteInPlace electron/main.cjs \
      --replace-fail "process.resourcesPath" "'${resourcesDir}'"
  '';

  # beforePack downloads ffmpeg; stage it here instead
  preBuild = ''
    jq 'del(.build.beforePack, .build.generateUpdatesFilesForAllChannels)' package.json > package.json.tmp
    mv package.json.tmp package.json
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # afterPack verifies a Koffi copy that only beforePack downloads
    jq 'del(.build.afterPack) | .build.mac.icon = "build/icon.icns"' package.json > package.json.tmp
    mv package.json.tmp package.json
    magick build/icon.png build/icon.icns
  ''
  + ''
    mkdir -p build/ffmpeg/${platformDir}
    ln -s ${lib.getExe' ffmpeg_8 "ffmpeg"} build/ffmpeg/${platformDir}/ffmpeg
  '';

  postBuild = ''
    cp -r ${electron.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
      --dir \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron.version} \
      -c.npmRebuild=false \
      ${lib.optionalString stdenv.hostPlatform.isDarwin "-c.mac.identity=null"}
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/{Applications,bin}
    cp -r release/mac*/Folia.app $out/Applications
    makeWrapper $out/Applications/Folia.app/Contents/MacOS/Folia $out/bin/folia-major
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/share/folia-major
    cp -r release/*-unpacked/resources $out/share/folia-major/

    install -Dm644 build/icon.png $out/share/icons/hicolor/512x512/apps/folia-major.png
    install -Dm644 packaging/linux/folia-major.desktop -t $out/share/applications
    substituteInPlace $out/share/applications/folia-major.desktop \
      --replace-fail "__APP_PATH__" "folia-major" \
      --replace-fail "__ICON_PATH__" "folia-major"

    makeWrapper ${lib.getExe electron} $out/bin/folia-major \
      --add-flags $out/share/folia-major/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
      --inherit-argv0
  ''
  + ''
    runHook postInstall
  '';

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

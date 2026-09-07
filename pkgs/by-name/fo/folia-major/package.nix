{
  lib,
  stdenvNoCC,
  buildNpmPackage,
  fetchFromGitHub,
  jq,
  imagemagick,
  makeWrapper,
  electron,
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
  version = "0.7.3";

  strictDeps = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "chthollyphile";
    repo = "folia-major";
    tag = "v${finalAttrs.version}";
    hash = "sha256-EwPD9apPbR0wnBKu6V8LkbXgS4bn9zVmVDNt2rND2jE=";
  };

  npmDepsHash = "sha256-Gywa4OH1NE4Rz8OH6cX1Tn8/M6CyQd/XNeagxzjjb8I=";

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

  installPhase =
    if stdenvNoCC.hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/{Applications,bin}
        cp -r release/mac*/Folia.app $out/Applications
        makeWrapper $out/Applications/Folia.app/Contents/MacOS/Folia $out/bin/folia-major

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir -p $out/share/folia-major
        cp -r release/*-unpacked/{locales,resources{,.pak}} $out/share/folia-major/

        install -D build/icon.png $out/share/icons/hicolor/512x512/apps/folia-major.png

        makeWrapper '${lib.getExe electron}' $out/bin/folia-major \
          --add-flags $out/share/folia-major/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
          --set-default ELECTRON_FORCE_IS_PACKAGED 1 \
          --set-default ELECTRON_IS_DEV 0 \
          --inherit-argv0

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
    homepage = "https://folia-site.vercel.app/";
    downloadPage = "https://github.com/chthollyphile/folia-major/releases";
    license = lib.licenses.agpl3Only;
    mainProgram = "folia-major";
    maintainers = with lib.maintainers; [ chillcicada ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

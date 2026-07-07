{
  lib,
  stdenv,
  buildNpmPackage,
  copyDesktopItems,
  devsy,
  electron_43,
  fetchFromGitHub,
  makeDesktopItem,
  makeWrapper,
  nix-update-script,
  nodejs_24,
}:

buildNpmPackage (finalAttrs: {
  pname = "devsy-desktop";
  version = "1.16.2";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "devsy-org";
    repo = "devsy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-tp79X1TXDaPL2+pAK90WllRWXmHGl5ySzT/X7KSyGGg=";
  };

  sourceRoot = "${finalAttrs.src.name}/desktop";

  nodejs = nodejs_24;

  npmDepsHash = "sha256-G5YhU4irLH0+xcSri4/nay9PC3UPBfSvj3VoedjCkXk=";

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = 1;
    PLAYWRIGHT_SKIP_BROWSER_DOWNLOAD = 1;
    npm_config_build_from_source = "true";
    npm_config_disturl = "https://electronjs.org/headers";
    npm_config_nodedir = "${electron_43.headers}";
    npm_config_runtime = "electron";
    npm_config_target = electron_43.version;
  };

  nativeBuildInputs = [
    makeWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    copyDesktopItems
  ];

  makeCacheWritable = true;

  buildPhase = ''
    runHook preBuild

    install -Dm755 ${lib.getExe devsy} resources/bin/devsy

    npm run electron:build

    cp -r ${electron_43.dist} electron-dist
    chmod -R u+w electron-dist

    npm exec electron-builder -- \
      --dir \
      --config electron-builder.yml \
      -c.electronDist=electron-dist \
      -c.electronVersion=${electron_43.version} \
      -c.npmRebuild=false \
      -c.mac.identity=null \
      -c.mac.notarize=false \
      -c.mac.gatekeeperAssess=false

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/Applications" "$out/bin"
    cp -R release/mac*/Devsy.app "$out/Applications/"

    makeWrapper "$out/Applications/Devsy.app/Contents/MacOS/Devsy" "$out/bin/devsy-desktop" \
      --set-default ELECTRON_IS_DEV 0 \
      --set DEVSY_CLI_PATH "$out/Applications/Devsy.app/Contents/Resources/bin/devsy"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p "$out/share/devsy-desktop" "$out/bin"
    cp -r release/linux*-unpacked/{locales,resources{,.pak}} "$out/share/devsy-desktop/"

    makeWrapper ${lib.getExe electron_43} "$out/bin/devsy-desktop" \
      --add-flags "$out/share/devsy-desktop/resources/app.asar" \
      --add-flags "''${NIXOS_OZONE_WL:+''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --set-default ELECTRON_IS_DEV 0 \
      --set DEVSY_CLI_PATH "$out/share/devsy-desktop/resources/bin/devsy" \
      --inherit-argv0

    install -Dm644 resources/icons/32x32.png "$out/share/icons/hicolor/32x32/apps/devsy.png"
    install -Dm644 resources/icons/128x128.png "$out/share/icons/hicolor/128x128/apps/devsy.png"
  ''
  + ''
    runHook postInstall
  '';

  desktopItems = lib.optionals stdenv.hostPlatform.isLinux [
    (makeDesktopItem {
      name = "devsy-desktop";
      exec = "devsy-desktop %U";
      icon = "devsy";
      desktopName = "Devsy";
      comment = "Deploy devcontainers onto any cloud provider, Kubernetes cluster, and docker";
      categories = [ "Development" ];
      startupWMClass = "Devsy";
      mimeTypes = [ "x-scheme-handler/devsy" ];
    })
  ];

  doInstallCheck = stdenv.buildPlatform.canExecute stdenv.hostPlatform;

  installCheckPhase = ''
    runHook preInstallCheck

    test -x "$out/bin/devsy-desktop"

  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    test -d "$out/Applications/Devsy.app"
    bundledCli="$out/Applications/Devsy.app/Contents/Resources/bin/devsy"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    test -f "$out/share/applications/devsy-desktop.desktop"
    test -f "$out/share/icons/hicolor/128x128/apps/devsy.png"
    bundledCli="$out/share/devsy-desktop/resources/bin/devsy"
  ''
  + ''
    test -x "$bundledCli"
    "$bundledCli" --version | grep -F "v${finalAttrs.version}"

    runHook postInstallCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Desktop app for deploying devcontainers onto cloud providers, Kubernetes, and Docker";
    homepage = "https://devsy.sh";
    changelog = "https://github.com/devsy-org/devsy/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mpl20;
    maintainers = with lib.maintainers; [ tyceherrman ];
    mainProgram = "devsy-desktop";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

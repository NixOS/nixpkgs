{
  lib,
  stdenvNoCC,
  fetchFromGitHub,
  cacert,
  yarn-berry,
  electron,
  makeWrapper,
  writableTmpDirAsHomeHook,
  makeDesktopItem,
  copyDesktopItems,
  commandLineArgs ? "",
}:

stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "cherry-studio";
  version = "1.1.10";

  src = fetchFromGitHub {
    owner = "CherryHQ";
    repo = "cherry-studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-rTIUBlQemYOAT0NRS80FcZfEc1Q9jUmlMU5YW99z0QE=";
  };

  yarnOfflineCache = stdenvNoCC.mkDerivation {
    name = "${finalAttrs.pname}-${finalAttrs.version}-offline-cache";
    inherit (finalAttrs) src;

    nativeBuildInputs = [
      cacert
      yarn-berry
      writableTmpDirAsHomeHook
    ];

    postConfigure = ''
      yarn config set enableTelemetry false
      yarn config set enableGlobalCache false
      yarn config set --json supportedArchitectures.os '[ "linux", "darwin" ]'
      yarn config set --json supportedArchitectures.cpu '["arm", "arm64", "ia32", "x64"]'
      yarn config set cacheFolder $out
    '';

    buildPhase = ''
      runHook preBuild

      yarn install --mode=skip-build

      runHook postBuild
    '';

    outputHashMode = "recursive";
    outputHash = "sha256-GVIa8/rNdYTcPYqaRZp8VGKeh0IiNttXzJEVvCpCAQo=";
  };

  nativeBuildInputs = [
    yarn-berry
    makeWrapper
    writableTmpDirAsHomeHook
    copyDesktopItems
  ];

  env.ELECTRON_SKIP_BINARY_DOWNLOAD = "1";

  postConfigure = ''
    yarn config set enableTelemetry false
    yarn config set enableGlobalCache false
    export cachePath=$(mktemp -d)
    cp -r $yarnOfflineCache/* $cachePath
    yarn config set cacheFolder $cachePath
    yarn install --mode=skip-build
  '';

  buildPhase = ''
    runHook preBuild

    yarn run electron-vite build
    yarn run electron-builder --linux --dir \
      --config electron-builder.yml \
      -c.electronDist="${electron}/libexec/electron" \
      -c.electronVersion=${electron.version}

    runHook postBuild
  '';

  desktopItems = [
    (makeDesktopItem {
      name = "cherry-studio";
      desktopName = "Cherry Studio";
      comment = "A powerful AI assistant for producer.";
      exec = "cherry-studio --no-sandbox %U";
      terminal = false;
      icon = "cherry-studio";
      startupWMClass = "Cherry Studio";
      categories = [ "Utility" ];
    })
  ];

  installPhase = ''
    runHook preInstall

    mkdir -p $out/lib/cherry-studio
    cp -r dist/linux-unpacked/{resources,LICENSE*} $out/lib/cherry-studio
    install -Dm644 build/icon.png $out/share/pixmaps/cherry-studio.png
    makeWrapper ${lib.getExe electron} $out/bin/cherry-studio \
      --inherit-argv0 \
      --add-flags $out/lib/cherry-studio/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}

    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Desktop client that supports for multiple LLM providers";
    homepage = "https://github.com/CherryHQ/cherry-studio";
    changelog = "https://github.com/CherryHQ/cherry-studio/releases/tag/v${finalAttrs.version}";
    mainProgram = "cherry-studio";
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ];
    license = with lib.licenses; [
      asl20
      unfree
    ];
  };
})

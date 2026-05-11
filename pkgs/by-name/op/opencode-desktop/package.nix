{
  bun,
  copyDesktopItems,
  electron_41,
  lib,
  makeBinaryWrapper,
  models-dev,
  nodejs,
  opencode,
  stdenvNoCC,
  writableTmpDirAsHomeHook,

  commandLineArgs ? "",
}:

let
  electron = electron_41;
in
stdenvNoCC.mkDerivation (finalAttrs: {
  pname = "opencode-desktop";
  inherit (opencode)
    version
    src
    node_modules
    patches
    ;

  nativeBuildInputs = [
    bun
    nodejs # for patchShebangs node_modules
    makeBinaryWrapper
    writableTmpDirAsHomeHook
    copyDesktopItems
  ];

  strictDeps = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    OPENCODE_CHANNEL = "prod";
    MODELS_DEV_API_JSON = "${models-dev}/dist/_api.json";
    OPENCODE_DISABLE_MODELS_FETCH = true;
  };

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/. .
    patchShebangs node_modules
    patchShebangs packages/*/node_modules

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # Build the opencode node bundle (needed by the desktop sidecar)
    cd packages/opencode
    bun --bun ./script/build-node.ts --skip-install
    cd ../..

    # Prepare desktop app
    cd packages/desktop

    # Copy prod icons
    cp -R icons/prod resources/icons

    # Build with electron-vite
    node_modules/.bin/electron-vite build

    # Copy opencode CLI as sidecar
    sidecar_name="opencode-cli"
    install -D ${lib.getExe opencode} "resources/$sidecar_name"

    # Package with electron-builder (unpacked directory mode)
    cp -r "${electron.dist}" $HOME/.electron-dist
    chmod -R u+w $HOME/.electron-dist

    node_modules/.bin/electron-builder --dir \
      --config=electron-builder.config.ts \
      --config.electronDist="$HOME/.electron-dist" \
      --config.electronVersion=${electron.version}

    cd ../..

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenvNoCC.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv packages/desktop/dist/mac-*/OpenCode.app "$out/Applications/OpenCode.app"
  ''
  + lib.optionalString stdenvNoCC.hostPlatform.isLinux ''
    mkdir -p $out/opt/opencode-desktop
    ${
      if stdenvNoCC.hostPlatform.isAarch64 then
        ''
          appDir="packages/desktop/dist/linux-arm64-unpacked"
        ''
      else
        ''
          appDir="packages/desktop/dist/linux-unpacked"
        ''
    }
    [ -d "$appDir" ] || { echo "no electron-builder output dir found: $appDir"; exit 1; }
    cp -r "$appDir/resources" $out/opt/opencode-desktop/

    install -Dm644 packages/desktop/resources/icons/icon.png $out/share/icons/opencode-desktop.png

    makeWrapper ${lib.getExe electron} $out/bin/opencode-desktop \
      --inherit-argv0 \
      --add-flags $out/opt/opencode-desktop/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  ''
  + ''
    runHook postInstall
  '';

  meta = {
    description = "AI coding agent desktop client";
    homepage = "https://opencode.ai";
    inherit (opencode.meta) platforms;
    license = lib.licenses.mit;
    mainProgram = "OpenCode";
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
  };
})

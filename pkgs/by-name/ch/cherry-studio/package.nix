{
  lib,
  stdenv,
  fetchFromGitHub,
  yarn-berry_4,
  nodejs,
  electron_37,
  autoPatchelfHook,
  makeWrapper,
  writableTmpDirAsHomeHook,
  makeDesktopItem,
  copyDesktopItems,
  commandLineArgs ? "",
}:

let
  electron = electron_37;
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cherry-studio";
  version = "1.7.1";

  src = fetchFromGitHub {
    owner = "CherryHQ";
    repo = "cherry-studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-A+J00wHJyCrxZSG80FKHw/c9EUfJP53v0KLjE9Jgmp8=";
  };

  postPatch = ''
    substituteInPlace src/main/services/ConfigManager.ts \
      --replace-fail "ConfigKeys.AutoUpdate, true" "ConfigKeys.AutoUpdate, false" \
      --replace-fail "ConfigKeys.AutoUpdate, value" "ConfigKeys.AutoUpdate, false"
    substituteInPlace src/main/services/AppUpdater.ts \
      --replace-fail " = isActive" " = false"
    substituteInPlace src/renderer/src/hooks/useSettings.ts \
      --replace-fail "isAutoUpdate)" "false)"
  '';

  missingHashes = ./missing-hashes.json;

  offlineCache = yarn-berry.fetchYarnBerryDeps {
    inherit (finalAttrs) src missingHashes;
    hash = "sha256-UZm0XJ/pjfADETd6sFoMCRB0axod3WybVW+RcPuX8ms=";
  };

  nativeBuildInputs = [
    yarn-berry.yarnBerryConfigHook
    yarn-berry
    autoPatchelfHook
    makeWrapper
    writableTmpDirAsHomeHook
    copyDesktopItems
    nodejs
    (nodejs.python.withPackages (ps: with ps; [ setuptools ]))
  ];

  env = {
    YARN_ENABLE_SCRIPTS = "false";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

  buildPhase = ''
    runHook preBuild

    cp -r "${electron.dist}" $HOME/.electron-dist
    chmod -R u+w $HOME/.electron-dist

    yarn run electron-vite build
    yarn run electron-builder --dir \
      --config=electron-builder.yml \
      --config.mac.identity=null \
      --config.electronDist="$HOME/.electron-dist" \
      --config.electronVersion=${electron.version}

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
      startupWMClass = "CherryStudio";
      categories = [ "Utility" ];
      mimeTypes = [ "x-scheme-handler/cherrystudio" ];
    })
  ];

  installPhase = ''
    runHook preInstall
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p $out/Applications
    mv "dist/mac-${stdenv.hostPlatform.darwinArch}/Cherry Studio.app" "$out/Applications/Cherry Studio.app"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    mkdir -p $out/opt/cherry-studio
    ${
      if stdenv.hostPlatform.isAarch64 then
        "cp -r dist/linux-arm64-unpacked/{resources,LICENSE*} $out/opt/cherry-studio"
      else
        "cp -r dist/linux-unpacked/{resources,LICENSE*} $out/opt/cherry-studio"
    }
    install -Dm644 build/icon.png $out/share/pixmaps/cherry-studio.png
    makeWrapper ${lib.getExe electron} $out/bin/cherry-studio \
      --inherit-argv0 \
      --add-flags $out/opt/cherry-studio/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  ''
  + ''
    runHook postInstall
  '';

  passthru.updateScript = ./update.sh;

  meta = {
    description = "Desktop client that supports for multiple LLM providers";
    homepage = "https://github.com/CherryHQ/cherry-studio";
    changelog = "https://github.com/CherryHQ/cherry-studio/releases/tag/v${finalAttrs.version}";
    mainProgram = "cherry-studio";
    platforms = with lib.platforms; linux ++ darwin;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    license = with lib.licenses; [ agpl3Only ];
  };
})

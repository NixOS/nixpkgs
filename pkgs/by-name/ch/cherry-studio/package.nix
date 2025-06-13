{
  lib,
  stdenv,
  fetchFromGitHub,
  yarn-berry_4,
  nodejs,
  python3,
  electron,
  makeWrapper,
  writableTmpDirAsHomeHook,
  makeDesktopItem,
  copyDesktopItems,
  commandLineArgs ? "",
}:

let
  yarn-berry = yarn-berry_4;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cherry-studio";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner = "CherryHQ";
    repo = "cherry-studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-P7nam15AhwFIy3qisp2cogJeCGe0sgNnF+eFl4ssf0Q=";
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
    hash = "sha256-OFinYvzLEXahaLY5YZM4eamiMUSPJZ1nUCzo8hQdnFw=";
  };

  nativeBuildInputs = [
    yarn-berry.yarnBerryConfigHook
    yarn-berry
    makeWrapper
    writableTmpDirAsHomeHook
    copyDesktopItems
    (python3.withPackages (ps: with ps; [ setuptools ]))
    nodejs
  ];

  env = {
    YARN_ENABLE_SCRIPTS = "false";
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
  };

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
      startupWMClass = "CherryStudio";
      categories = [ "Utility" ];
      mimeTypes = [ "x-scheme-handler/cherrystudio" ];
    })
  ];

  installPhase = ''
    runHook preInstall

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
    license = with lib.licenses; [ agpl3Only ];
  };
})

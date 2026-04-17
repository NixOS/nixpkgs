{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  electron_40,
  nodejs-slim,
  pnpm_10_29_2,
  pnpmConfigHook,
  makeWrapper,
  writableTmpDirAsHomeHook,
  copyDesktopItems,
  cctools,
  autoPatchelfHook,
  pkg-config,
  makeDesktopItem,
  nix-update-script,
  alsa-lib,
  libevdev,
  libx11,
  libxi,
  libxfixes,
  libxtst,
  wayland,
  commandLineArgs ? "",
}:

let
  electron = electron_40;
  pnpm = pnpm_10_29_2;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cherry-studio";
  version = "1.9.1";

  src = fetchFromGitHub {
    owner = "CherryHQ";
    repo = "cherry-studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-gk/sTkBr7PKBGS96bYVUXGpZuoaech4/0npB+NSstTA=";
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

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 3;
    hash = "sha256-DidMffZQEdYSERZZgDpQ8DqV773iBju89Pa0Z1Gz3I8=";
  };

  nativeBuildInputs = [
    nodejs-slim
    (nodejs-slim.python.withPackages (ps: with ps; [ setuptools ]))
    pnpm
    pnpmConfigHook
    makeWrapper
    writableTmpDirAsHomeHook
    copyDesktopItems
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ cctools.libtool ]
  ++ lib.optionals stdenv.hostPlatform.isElf [
    autoPatchelfHook
    pkg-config
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    stdenv.cc.cc.lib
    alsa-lib
    libevdev
    libx11
    libxi
    libxtst
    libxfixes
    wayland
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-*.so.*"
  ];

  strictDeps = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isLinux "-I${lib.getDev libevdev}/include/libevdev-1.0";
  };

  buildPhase = ''
    runHook preBuild

    cp -r "${electron.dist}" $HOME/.electron-dist
    chmod -R u+w $HOME/.electron-dist

    node_modules/.bin/electron-vite build
    npm_config_nodedir=${electron.headers} npm_config_build_from_source=true node_modules/.bin/electron-builder --dir \
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
    install -Dm644 build/icon.png $out/share/icons/cherry-studio.png
    makeWrapper ${lib.getExe electron} $out/bin/cherry-studio \
      --inherit-argv0 \
      --add-flags $out/opt/cherry-studio/resources/app.asar \
      --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true --wayland-text-input-version=3}}" \
      --add-flags ${lib.escapeShellArg commandLineArgs}
  ''
  + ''
    runHook postInstall
  '';

  passthru.updateScript = nix-update-script { };

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

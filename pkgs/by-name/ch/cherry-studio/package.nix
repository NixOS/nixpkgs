{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  electron_41,
  nodejs-slim,
  pnpm_11,
  pnpmConfigHook,
  makeWrapper,
  writableTmpDirAsHomeHook,
  copyDesktopItems,
  cctools,
  autoPatchelfHook,
  pkg-config,
  makeDesktopItem,
  nix-update-script,
  bun,
  mise,
  ripgrep,
  uv,
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
  electron = electron_41;
  pnpm = pnpm_11;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cherry-studio";
  version = "2.0.7";

  src = fetchFromGitHub {
    owner = "CherryHQ";
    repo = "cherry-studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-K49Y03OF2RyhUUhhKo4YCR4ObgnsBbBfhl2wqe1+xvs=";
  };

  patches = [
    # Upstream's packaging hooks download prebuilt binaries (mise, bun, uv,
    # ripgrep, and a GLIBC-compatible better-sqlite3 addon) from GitHub during
    # electron-builder packaging. That needs network access, which the build
    # sandbox doesn't have. The tools are resolved from PATH at runtime
    # instead (see the wrapper below), and better-sqlite3 is rebuilt from
    # source against electron by electron-builder.
    ./skip-binary-download.patch
  ];

  postPatch = ''
    substituteInPlace src/shared/data/preference/preferenceSchemas.ts \
      --replace-fail "'app.dist.auto_update.enabled': true" "'app.dist.auto_update.enabled': false"
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 4;
    hash = "sha256-bwfDr6z1/uBO1D0lTpO061nnrDunRjN9InxiT1MABAY=";
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
      --prefix PATH : ${
        lib.makeBinPath [
          bun
          mise
          ripgrep
          uv
        ]
      } \
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
    license = lib.licenses.agpl3Only;
  };
})

{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchPnpmDeps,
  git,
  electron_45,
  nodejs-slim,
  pnpm_12,
  pnpmConfigHook,
  makeWrapper,
  writableTmpDirAsHomeHook,
  copyDesktopItems,
  cctools,
  swift,
  swiftpm,
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
  glib,
  gdk-pixbuf,
  dbus,
  rust-jemalloc-sys,
  aws-lc,
  zstd,
  openssl,
  commandLineArgs ? "",
}:

let
  electron = electron_45;
  pnpm = pnpm_12;
in
stdenv.mkDerivation (finalAttrs: {
  pname = "cherry-studio";
  version = "2.2.1";

  src = fetchFromGitHub {
    owner = "CherryHQ";
    repo = "cherry-studio";
    tag = "v${finalAttrs.version}";
    hash = "sha256-4IUfue2tj7EuwXa4kXz2ORxkpyHJmntcWUyswCX4Yuk=";
  };

  patches = [
    # Avoid network access and Docker in upstream's packaging hooks. External
    # tools are bundled from nixpkgs, and native addons are built from source.
    ./skip-binary-download.patch
  ];

  postPatch = ''
    substituteInPlace src/shared/data/preference/preferenceSchemas.ts \
      --replace-fail "'app.dist.auto_update.enabled': true" "'app.dist.auto_update.enabled': false"
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace src/main/core/paths/pathRegistry.ts src/main/data/migration/v2/core/MigrationPaths.ts \
      --replace-fail "process.resourcesPath" "'$out/opt/cherry-studio/resources'"
  '';

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    nativeBuildInputs = [ git ];
    fetcherVersion = 5;
    hash = "sha256-9JTJgo6UnAROmpBayXtsi5kmov/0F7CGkDBCkok/c98=";
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
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    cctools.libtool
    swift
    swiftpm
  ]
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
    glib
    gdk-pixbuf
    dbus
    rust-jemalloc-sys
    aws-lc
    zstd
    openssl
  ];

  autoPatchelfIgnoreMissingDeps = [
    "libc.musl-*.so.*"
  ];

  strictDeps = true;
  __structuredAttrs = true;

  env = {
    ELECTRON_SKIP_BINARY_DOWNLOAD = "1";
    NIX_CFLAGS_COMPILE = lib.optionalString stdenv.hostPlatform.isLinux "-I${lib.getDev libevdev}/include/libevdev-1.0";
  };

  buildPhase = ''
    runHook preBuild

    cp -r "${electron.dist}" $HOME/.electron-dist
    chmod -R u+w $HOME/.electron-dist

    pnpm run postinstall
    node_modules/.bin/electron-vite build
    node_modules/.bin/electron-vite build --config electron.vite.entries.config.ts

    bundledBinaries=resources/binaries/${stdenv.hostPlatform.node.platform}-${stdenv.hostPlatform.node.arch}
    mkdir -p "$bundledBinaries"
    ln -s ${lib.getExe mise} "$bundledBinaries/mise"
    ln -s ${lib.getExe bun} "$bundledBinaries/bun"
    ln -s ${lib.getExe uv} "$bundledBinaries/uv"
    ln -s ${lib.getExe' uv "uvx"} "$bundledBinaries/uvx"
    ln -s ${lib.getExe ripgrep} "$bundledBinaries/rg"
    echo ${mise.version} > "$bundledBinaries/.mise-version"
    echo ${bun.version} > "$bundledBinaries/.bun-version"
    echo ${uv.version} > "$bundledBinaries/.uv-version"
    echo ${ripgrep.version} > "$bundledBinaries/.rg-version"

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
      --set ELECTRON_FORCE_IS_PACKAGED 1 \
      --add-flags "--no-sandbox" \
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

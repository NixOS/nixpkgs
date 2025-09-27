{
  lib,
  stdenv,
  stdenvNoCC,
  fetchFromGitHub,
  rustPlatform,
  electron_35,
  nodejs_22,
  yarn-berry_4,
  cacert,
  writableTmpDirAsHomeHook,
  cargo,
  rustc,
  findutils,
  zip,
  rsync,
  jq,
  copyDesktopItems,
  makeWrapper,
  llvmPackages,
  apple-sdk_15,
  makeDesktopItem,
  nix-update-script,
  buildType ? "stable",
  commandLineArgs ? "",
}:
let
  hostPlatform = stdenvNoCC.hostPlatform;
  nodePlatform = hostPlatform.node.platform;
  nodeArch = hostPlatform.node.arch;
  electron = electron_35;
  nodejs = nodejs_22;
  yarn-berry = yarn-berry_4.override { inherit nodejs; };
  productName = if buildType != "stable" then "AFFiNE-${buildType}" else "AFFiNE";
  binName = lib.toLower productName;
in
stdenv.mkDerivation (finalAttrs: {
  pname = binName;

  version = "0.24.1";
  src = fetchFromGitHub {
    owner = "toeverything";
    repo = "AFFiNE";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Yq5TD5yInv+0d1S6M58I8CneCAGUwH0ThGrEJfLIrX0=";
  };

  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs) pname version src;
    hash = "sha256-tRDc7Rky59Rh08QTNiG3yopErHJzARxN8BZGrSUECLE=";
  };
  yarnOfflineCache = stdenvNoCC.mkDerivation {
    name = "yarn-offline-cache";
    inherit (finalAttrs) src;
    nativeBuildInputs = [
      yarn-berry
      cacert
      writableTmpDirAsHomeHook
    ];
    # force yarn install run in CI mode
    env.CI = "1";
    buildPhase =
      let
        supportedArchitectures = builtins.toJSON {
          os = [
            "darwin"
            "linux"
          ];
          cpu = [
            "x64"
            "ia32"
            "arm64"
          ];
          libc = [
            "glibc"
            "musl"
          ];
        };
      in
      ''
        runHook preBuild

        mkdir -p $out
        yarn config set enableTelemetry false
        yarn config set cacheFolder $out
        yarn config set enableGlobalCache false
        yarn config set supportedArchitectures --json '${supportedArchitectures}'

        yarn install --immutable --mode=skip-build

        runHook postBuild
      '';
    dontInstall = true;
    outputHashMode = "recursive";
    outputHash = "sha256-U2FGvdtGiM97aXmbfNIfi87hvwDkd1dvlAABYiDgAGI=";
  };

  buildInputs = lib.optionals hostPlatform.isDarwin [
    apple-sdk_15
  ];

  nativeBuildInputs = [
    nodejs
    yarn-berry
    cargo
    rustc
    findutils
    zip
    jq
    rsync
    writableTmpDirAsHomeHook
  ]
  ++ lib.optionals hostPlatform.isLinux [
    copyDesktopItems
    makeWrapper
  ]
  ++ lib.optionals hostPlatform.isDarwin [
    # bindgenHook is needed to build `coreaudio-sys` on darwin
    rustPlatform.bindgenHook
  ];

  env = {
    # force yarn install run in CI mode
    CI = "1";
    # `LIBCLANG_PATH` is needed to build `coreaudio-sys` on darwin
    LIBCLANG_PATH = lib.optionalString hostPlatform.isDarwin "${lib.getLib llvmPackages.libclang}/lib";
  };

  # Remove code under The AFFiNE Enterprise Edition (EE) license.
  # Keep file package.json for `yarn install --immutable` lockfile check.
  postPatch = ''
    BACKEND_SERVER_PACKAGE_JSON="$(jq 'del(.scripts.postinstall)' packages/backend/server/package.json)"
    rm -rf packages/backend/server/{.*,*}
    echo "$BACKEND_SERVER_PACKAGE_JSON" > packages/backend/server/package.json
  '';

  configurePhase = ''
    runHook preConfigure

    # cargo config
    mkdir -p .cargo
    cat $cargoDeps/.cargo/config.toml >> .cargo/config.toml
    ln -s $cargoDeps @vendor@

    # yarn config
    yarn config set enableTelemetry false
    yarn config set enableGlobalCache false
    yarn config set cacheFolder $yarnOfflineCache

    # electron config
    ELECTRON_VERSION_IN_LOCKFILE=$(yarn why electron --json | tail --lines 1 | jq --raw-output '.children | to_entries | first | .key ' | cut -d : -f 2)
    rsync --archive --chmod=u+w "${electron.dist}/" $HOME/.electron-prebuilt-zip-tmp
    export ELECTRON_FORGE_ELECTRON_ZIP_DIR=$PWD/.electron_zip_dir
    mkdir -p $ELECTRON_FORGE_ELECTRON_ZIP_DIR
    (cd $HOME/.electron-prebuilt-zip-tmp && zip --recurse-paths - .) > $ELECTRON_FORGE_ELECTRON_ZIP_DIR/electron-v$ELECTRON_VERSION_IN_LOCKFILE-${nodePlatform}-${nodeArch}.zip
    export ELECTRON_SKIP_BINARY_DOWNLOAD=1

    runHook postConfigure
  '';

  buildPhase = ''
    runHook preBuild

    # first build
    yarn install
    CARGO_NET_OFFLINE=true yarn affine @affine/native build
    GITHUB_SHA=ffffffffffffffffffffffffffffffffffffffff BUILD_TYPE=${buildType} SKIP_NX_CACHE=1 yarn affine @affine/electron generate-assets

    # second build
    yarn config set nmMode classic
    yarn config set nmHoistingLimits workspaces
    find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
    yarn install
    BUILD_TYPE=${buildType} SKIP_WEB_BUILD=1 SKIP_BUNDLE=1 HOIST_NODE_MODULES=1 yarn affine @affine/electron make

    runHook postBuild
  '';

  installPhase =
    if hostPlatform.isDarwin then
      ''
        runHook preInstall

        mkdir -p $out/Applications
        mv packages/frontend/apps/electron/out/${buildType}/${productName}-darwin-${nodeArch}/${productName}.app $out/Applications

        runHook postInstall
      ''
    else
      ''
        runHook preInstall

        mkdir --parents $out/lib/${binName}/
        mv packages/frontend/apps/electron/out/${buildType}/${productName}-linux-${nodeArch}/{resources,LICENSE*} $out/lib/${binName}/
        install -Dm644 packages/frontend/apps/electron/resources/icons/icon_${buildType}_64x64.png $out/share/icons/hicolor/64x64/apps/${binName}.png

        makeWrapper "${lib.getExe electron}" $out/bin/${binName} \
          --inherit-argv0 \
          --add-flags $out/lib/${binName}/resources/app.asar \
          --add-flags "\''${NIXOS_OZONE_WL:+\''${WAYLAND_DISPLAY:+--ozone-platform-hint=auto --enable-features=WaylandWindowDecorations --enable-wayland-ime=true}}" \
          --add-flags ${lib.escapeShellArg commandLineArgs}

        runHook postInstall
      '';

  desktopItems = [
    (makeDesktopItem {
      name = binName;
      desktopName = productName;
      comment = "AFFiNE Desktop App";
      exec = "${binName} %U";
      terminal = false;
      icon = binName;
      startupWMClass = binName;
      categories = [ "Utility" ];
      mimeTypes = [ "x-scheme-handler/${binName}" ];
    })
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [
      "--version-regex=^v(\\d+\\.\\d+\\.\\d+)$"
    ];
  };

  meta = {
    description = "Workspace with fully merged docs, whiteboards and databases";
    longDescription = ''
      AFFiNE is an open-source, all-in-one workspace and an operating
      system for all the building blocks that assemble your knowledge
      base and much more -- wiki, knowledge management, presentation
      and digital assets
    '';
    homepage = "https://affine.pro/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ xiaoxiangmoe ];
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-darwin"
      "x86_64-linux"
    ];
    sourceProvenance = [ lib.sourceTypes.fromSource ];
  };
})

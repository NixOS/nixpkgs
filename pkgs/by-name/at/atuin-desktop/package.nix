{
  lib,
  stdenv,
  fetchFromGitHub,
  rustPlatform,
  wrapGAppsHook4,
  nix-update-script,

  cargo-tauri,
  nodejs,
  pkg-config,
  bun,
  writableTmpDirAsHomeHook,

  alsa-lib,
  glib-networking,
  libappindicator-gtk3,
  openssl,
  webkitgtk_4_1,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "atuin-desktop";
  version = "0.2.15";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-lAOq8K6fN+Hdp1l7HN2hrtM6W3gois59+M9ihnpw418=";
  };

  cargoRoot = "./.";
  cargoHash = "sha256-Mnyx6cWKh5IHKn6tGMqUcybqoxTM4JLyhpEqNcREBzk=";

  node_modules = stdenv.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "atuin-destkop-node_modules";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      nodejs
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontPatchShebangs = true; # Patch shebangs manually in configurePhase after copying node_modules in the main derivation.

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      # Install dependencies without running lifecycle scripts:
      #  - Skip scripts to avoid running ts-tiny-activerecord's prepare script with unpatched shebangs.
      #  - Rebuild in the main derivation after shebangs are patched there manually.
      bun install --no-progress --frozen-lockfile --no-cache --ignore-scripts

      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall

      mkdir -p $out/node_modules
      cp -R ./node_modules $out

      runHook postInstall
    '';
    outputHash =
      {
        x86_64-linux = "sha256-i99tK83ps9fY5m6EydQ/paChIKHTezCUzrvW09cmxLA=";
        aarch64-linux = "sha256-EGui86p1V7R0t3I4aGeuxsinyUbik1iTh45WgkTNoTc=";
        aarch64-darwin = "sha256-+mAoj7RhJEoyx5YxJJYRhiaetKq2aY1vgdxb2xyNiwI=";
        x86_64-darwin = "sha256-T+OhfypoUNDXbgxDZ9XLbDWIVrn9KEvvPcPLCKUbDOc";
      }
      .${stdenv.hostPlatform.system}
        or (throw "${finalAttrs.pname}: Platform ${stdenv.hostPlatform.system} is not packaged yet.");
    outputHashMode = "recursive";
  };

  nativeBuildInputs = [
    cargo-tauri.hook
    rustPlatform.bindgenHook
    bun
    nodejs
    pkg-config
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook4 ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    alsa-lib
    glib-networking
    libappindicator-gtk3
    openssl
    webkitgtk_4_1
  ];

  env = {
    # Used upstream: https://github.com/atuinsh/desktop/blob/976df186a74ad9303f92ec56ea65da69234fd298/.envrc#L1
    NODE_OPTIONS = "--max-old-space-size=6144";

    # TMP: Fix build failure with GCC 15.
    NIX_CFLAGS_COMPILE = "-std=gnu17";
  };

  postPatch = ''
    # Skip TypeScript type checking to avoid errors with implicit any types.
    substituteInPlace package.json \
      --replace-fail '"build": "tsc && vite build"' '"build": "vite build"'
  '';

  # Otherwise tauri will look for a private key we don't have.
  tauriConf = builtins.toJSON { bundle.createUpdaterArtifacts = false; };
  passAsFile = [ "tauriConf" ];
  preBuild = ''
    tauriBuildFlags+=(
      "--config"
      "$tauriConfPath"
    )
  '';

  configurePhase = ''
    runHook preConfigure

    cp -R ${finalAttrs.node_modules}/node_modules .

    # Bun takes executables from this folder
    chmod -R u+rw node_modules
    chmod -R u+x node_modules/.bin

    patchShebangs node_modules

    # Run lifecycle scripts for ts-tiny-activerecord with patched shebangs:
    #  - ts-tiny-activerecord has a `prepare` script that compiles TypeScript into JavaScript.
    cd node_modules/ts-tiny-activerecord
    npm run prepare
    cd ../..

    export HOME=$TMPDIR
    export PATH="$PWD/node_modules/.bin:$PATH"

    runHook postConfigure
  '';

  passthru.updateScript = nix-update-script { };

  checkFlags = [
    "--skip=ui::viewport::tests::test_add_line_scrolling"
    "--skip=ui::viewport::tests::test_line_wrapping"
  ];
  doCheck = !stdenv.isDarwin;

  meta = {
    description = "Local-first, executable runbook editor";
    homepage = "https://atuin.sh";
    downloadPage = "https://github.com/atuinsh/desktop";
    changelog = "https://github.com/atuinsh/desktop/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [
      adda
      dzervas
      randoneering
    ];
    mainProgram = "atuin-desktop";
    platforms = with lib.platforms; windows ++ darwin ++ linux;
  };
})

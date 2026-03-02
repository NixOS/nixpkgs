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
  version = "0.2.20";

  src = fetchFromGitHub {
    owner = "atuinsh";
    repo = "desktop";
    tag = "v${finalAttrs.version}";
    hash = "sha256-8FMB64UeGhXpWD5w33okpOVwKInrQ5R33aZuKIRCFEs=";
  };

  cargoRoot = "./.";
  cargoDeps = rustPlatform.fetchCargoVendor {
    inherit (finalAttrs)
      # TMP: Include patches from root to ensure Cargo.lock consistency between root and deps.
      patches
      src
      ;
    hash = "sha256-eOFMUxXPQrhBthuQLgBsixe1vsniGUnoHb2EOhZQ/iY=";
  };

  patches = [
    # TMP: Until a duplicate entry for `tauri-build` dependency in `Cargo.lock` is resolved
    #  (https://github.com/atuinsh/desktop/issues/364), remove one of the duplicated entries.
    ./0001-fix-Remove-duplicate-dependency-entry-for-tauri-build.patch
  ];

  node_modules = stdenv.mkDerivation {
    inherit (finalAttrs) src version;
    pname = "${finalAttrs.pname}-node_modules";

    impureEnvVars = lib.fetchers.proxyImpureEnvVars ++ [
      "GIT_PROXY_COMMAND"
      "SOCKS_SERVER"
    ];

    nativeBuildInputs = [
      bun
      writableTmpDirAsHomeHook
    ];

    dontConfigure = true;
    dontFixup = true;
    dontPatchShebangs = true; # Patch shebangs manually in configurePhase after copying node_modules in the main derivation.

    buildPhase = ''
      runHook preBuild

      export BUN_INSTALL_CACHE_DIR=$(mktemp -d)

      # Install dependencies without running lifecycle scripts:
      #  - Skip scripts to avoid running ts-tiny-activerecord's prepare script with unpatched shebangs.
      #  - Rebuild in the main derivation after shebangs are patched there manually.
      bun install \
        --force \
        --no-progress \
        --frozen-lockfile \
        --ignore-scripts

      runHook postBuild
    '';
    installPhase = ''
      runHook preInstall

      cp -R ./node_modules $out

      runHook postInstall
    '';
    outputHash =
      {
        aarch64-darwin = "sha256-YbjDAa2KG8U0ODqIYc5h7iNr5px+6+iforDrPomOVDo=";
        aarch64-linux = "sha256-JoUPAfBF4xdQxtx+J/VNpYomBACNsL7Wes0XXuGByGk=";
        x86_64-darwin = "sha256-YzxQyZPfcQci8QsGEDRTcc2A9tmvem3cHkv/OBFlWDQ=";
        x86_64-linux = "sha256-w8fMS6f+F+23EtMjjl0RsHMm6b5jOXSwUDAc21vqLAg=";
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
    # Used upstream: https://github.com/atuinsh/desktop/blob/v0.2.19/.envrc#L1
    NODE_OPTIONS = "--max-old-space-size=6144";

    # TMP: Fix build failure with GCC 15.
    NIX_CFLAGS_COMPILE = "-std=gnu17";
  };

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

    cp -R ${finalAttrs.node_modules} node_modules/

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

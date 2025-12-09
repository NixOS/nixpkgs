{
  lib,
  stdenv,
  cacert,
  cargo-tauri,
  cmake,
  curl,
  desktop-file-utils,
  fetchFromGitHub,
  git,
  glib-networking,
  jq,
  libgit2,
  makeBinaryWrapper,
  moreutils,
  nix-update-script,
  nodejs,
  openssl,
  pkg-config,
  pnpm_10,
  rust,
  rustPlatform,
  turbo,
  webkitgtk_4_1,
  wrapGAppsHook4,
  yq,
}:

let
  pnpm = pnpm_10;
  excludeSpec = spec: [
    "--exclude"
    spec
  ];
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitbutler";
  version = "0.15.10";

  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-6sRSH7OSprOsRMoORjy9HI8SoOAXqPak2kqtgRx2bWI=";
  };

  # Workaround for https://github.com/NixOS/nixpkgs/issues/359340
  cargoPatches = [ ./gix-from-crates-io.patch ];

  # Let Tauri know what version we're building
  #
  # Remove references to non-existent workspaces in `gix` crates
  #
  # Deactivate the built-in updater
  postPatch = ''
    tauriConfRelease="crates/gitbutler-tauri/tauri.conf.release.json"
    jq '.version = "${finalAttrs.version}" | .bundle.createUpdaterArtifacts = false' "$tauriConfRelease" | sponge "$tauriConfRelease"

    tomlq -ti 'del(.lints) | del(.workspace.lints)' "$cargoDepsCopy"/gix*/Cargo.toml

    substituteInPlace apps/desktop/src/lib/backend/tauri.ts \
      --replace-fail 'checkUpdate = check;' 'checkUpdate = () => null;'
  '';

  cargoHash = "sha256-H8YR+euwMGiGckURAWJIE9fOcu/ddJ6ENcnA1gHD9B8=";

  pnpmDeps = pnpm.fetchDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-I55RNWP6csT08SBIFEyUp9JTC5EzQXjKIPPSxkSpg7Y=";
  };

  nativeBuildInputs = [
    cacert # Required by turbo
    cargo-tauri.hook
    cmake # Required by `zlib-sys` crate
    desktop-file-utils
    jq
    moreutils
    nodejs
    pkg-config
    pnpm.configHook
    turbo
    wrapGAppsHook4
    yq # For `tomlq`
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin makeBinaryWrapper;

  buildInputs = [
    libgit2
    openssl
  ]
  ++ lib.optional stdenv.hostPlatform.isDarwin curl
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    webkitgtk_4_1
  ];

  tauriBuildFlags = [
    "--config"
    "crates/gitbutler-tauri/tauri.conf.release.json"
  ];

  nativeCheckInputs = [ git ];

  # `gitbutler-git`'s checks do not support release mode
  checkType = "debug";
  cargoTestFlags = [
    "--workspace"
  ]
  ++ lib.concatMap excludeSpec [
    # Requires Git directories
    "but-core"
    "but-rebase"
    "but-workspace"
    # Fails due to the issues above and below
    "but-hunk-dependency"
    # Errors with "Lazy instance has previously been poisoned"
    "gitbutler-branch-actions"
    "gitbutler-stack"
    # `Expecting driver to be located at "../../target/debug/gitbutler-cli" - we also assume a certain crate location`
    # We're not (usually) building in debug mode and always have a different target directory, so...
    "gitbutler-edit-mode"
  ];

  env = {
    # Make sure `crates/gitbutler-tauri/inject-git-binaries.sh` can find our
    # target dir
    # https://github.com/gitbutlerapp/gitbutler/blob/56b64d778042d0e93fa362f808c35a7f095ab1d1/crates/gitbutler-tauri/inject-git-binaries.sh#L10C10-L10C26
    TRIPLE_OVERRIDE = rust.envVars.rustHostPlatformSpec;

    # `pnpm`'s `fetchDeps` and `configHook` uses a specific version of pnpm, not upstream's
    COREPACK_ENABLE_STRICT = 0;

    # We depend on nightly features
    RUSTC_BOOTSTRAP = 1;

    # We also need to have `tracing` support in `tokio` for `console-subscriber`
    RUSTFLAGS = "--cfg tokio_unstable";

    TUBRO_BINARY_PATH = lib.getExe turbo;

    OPENSSL_NO_VENDOR = true;
    LIBGIT2_NO_VENDOR = 1;
  };

  preBuild = ''
    turbo run --filter @gitbutler/svelte-comment-injector build
    pnpm build:desktop -- --mode production
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isDarwin ''
      makeBinaryWrapper $out/Applications/GitButler.app/Contents/MacOS/gitbutler-tauri $out/bin/gitbutler-tauri
    ''
    + lib.optionalString stdenv.hostPlatform.isLinux ''
      desktop-file-edit \
        --set-comment "A Git client for simultaneous branches on top of your existing workflow." \
        --set-key="Keywords" --set-value="git;" \
        --set-key="StartupWMClass" --set-value="GitButler" \
        $out/share/applications/GitButler.desktop
    '';

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "release/(.*)"
      ];
    };
  };

  meta = {
    description = "Git client for simultaneous branches on top of your existing workflow";
    homepage = "https://gitbutler.com";
    changelog = "https://github.com/gitbutlerapp/gitbutler/releases/tag/release/${finalAttrs.version}";
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [
      getchoo
      techknowlogick
    ];
    mainProgram = "gitbutler-tauri";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

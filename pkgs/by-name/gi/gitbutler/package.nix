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
  pnpm_9,
  rust,
  rustPlatform,
  turbo,
  webkitgtk_4_1,
  wrapGAppsHook4,
  yq,
}:

let
  excludeSpec = spec: [
    "--exclude"
    spec
  ];
in

rustPlatform.buildRustPackage rec {
  pname = "gitbutler";
  version = "0.14.4";

  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    tag = "release/${version}";
    hash = "sha256-JeiiV7OXRI4xTTQp1dXqT1ozTrIc7cltvZ6yVOhcjGU=";
  };

  # Deactivate the upstream updater, set the version, and merge Tauri's
  # configuration files
  #
  # Remove references to non-existent workspaces in `gix` crates
  postPatch = ''
    jq --slurp \
      '.[0] * .[1]
      | .version = "${version}"
      | .bundle.createUpdaterArtifacts = false
      | .plugins.updater.endpoints = [ ]' \
      crates/gitbutler-tauri/tauri.conf{,.release}.json \
      | sponge crates/gitbutler-tauri/tauri.conf.json

    tomlq -ti 'del(.lints) | del(.workspace.lints)' "$cargoDepsCopy"/gix*/Cargo.toml
  '';

  useFetchCargoVendor = true;
  cargoHash = "sha256-ooe9in3JfEPMbZSMjobVJpWZdqBTf2AsfEkcsQc0Fts=";

  pnpmDeps = pnpm_9.fetchDeps {
    inherit pname version src;
    hash = "sha256-bLuKG+7QncLwiwKDrlcHKaSrUmDaJUxdvpdv0Jc6UPo=";
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
    pnpm_9.configHook
    turbo
    wrapGAppsHook4
    yq # For `tomlq`
  ] ++ lib.optional stdenv.hostPlatform.isDarwin makeBinaryWrapper;

  buildInputs =
    [
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
    "crates/gitbutler-tauri/tauri.conf.json"
  ];

  nativeCheckInputs = [ git ];

  # `gitbutler-git`'s checks do not support release mode
  checkType = "debug";
  cargoTestFlags =
    [
      "--workspace"
    ]
    # Errors with "Lazy instance has previously been poisoned"
    ++ excludeSpec "gitbutler-branch-actions"
    ++ excludeSpec "gitbutler-stack";

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
    changelog = "https://github.com/gitbutlerapp/gitbutler/releases/tag/release/${version}";
    license = lib.licenses.fsl11Mit;
    maintainers = with lib.maintainers; [
      getchoo
      techknowlogick
    ];
    mainProgram = "gitbutler-tauri";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
}

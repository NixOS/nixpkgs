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
  fetchPnpmDeps,
  pnpmConfigHook,
  pnpm,
  rust,
  rustPlatform,
  turbo,
  webkitgtk_4_1,
  wrapGAppsHook4,
  dart-sass,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitbutler";
  version = "0.18.8";

  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-OSM2yjiz3I5+SVpcJSWCDyS4y4w9JJ/8CAP2BK0sL7o=";
  };

  # Workaround for https://github.com/NixOS/nixpkgs/issues/359340
  cargoPatches = [
    ./gix-from-crates-io.patch
  ];

  # Let Tauri know what version we're building and deactivate the built-in updater
  # Note: .bundle.externalBin doesn't include `"but"` at the moment
  #       as that'd require more build adjustments
  postPatch = ''
    tauriConfRelease="crates/gitbutler-tauri/tauri.conf.release.json"
    jq '.
        | (.version = "${finalAttrs.version}")
        | (.bundle.createUpdaterArtifacts = false)
        | (.bundle.externalBin = ["gitbutler-git-setsid", "gitbutler-git-askpass"])
      ' "$tauriConfRelease" | sponge "$tauriConfRelease"

    substituteInPlace apps/desktop/src/lib/backend/tauri.ts \
      --replace-fail 'checkUpdate = tauriCheck;' 'checkUpdate = () => null;'
  '';

  cargoHash = "sha256-L53iIVxv3KtmXiqITad1enIMX3Iu/mWSJJPZk7KAWuM=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-IAsEzM9kmZWnh390CV7mOyOshVlESsyoNT0ZvdY03KY=";
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
    pnpmConfigHook
    pnpm
    turbo
    wrapGAppsHook4
    dart-sass
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

  cargoTestFlags = [
    "--workspace"
  ]
  # Exclude these workspace crates from testing
  ++ lib.concatMap (crate: [ "--exclude=${crate}" ]) [
    # Requires Git directories
    "but-core"
    "but-rebase"
    "but-workspace"
    # Fails due to the issues above and below
    "but-hunk-dependency"
    # `Expecting driver to be located at "../../target/debug/gitbutler-cli" - we also assume a certain crate location`
    # We're not (usually) building in debug mode and always have a different target directory, so...
    "gitbutler-branch-actions"
    "gitbutler-stack"
    "gitbutler-edit-mode"
    "but-cherry-apply"
    "but-worktrees"
  ]
  ++ [
    "--"
  ]
  # Skip these specific tests
  ++ lib.concatMap (test: [ "--skip=${test}" ]) [
    # These tests try connecting to a local address (192.0.2.1) and expect the
    # connection to fail in a certain way. When run on macOS with a network
    # sandbox (?) these tests fail while preparing the socket.
    # https://github.com/NixOS/nixpkgs/pull/473706#issuecomment-3734337124
    "test_is_network_error"
    # assertion `left == right` failed: GIT_EDITOR should take precedence if git is executed correctly
    #  left: "vi"
    # right: "from-GIT_EDITOR"
    "git_editor_takes_precedence"
    # FLAKY (try again): child exited unsuccessfully: ExitStatus(unix_wait_status(10752))
    "migrations_in_parallel_with_processes"
    # Archive at 'tests/fixtures/generated-archives/[...].tar' not found [..] Error: No such file or directory (os error 2)
    "merge_first_branch_into_gb_local_and_verify_rebase"
    "json_output_with_dangling_commits"
    "two_dangling_commits_different_branches"
    # darwin: Error: timeout waiting for matching event
    "track_directory_changes_after_rename"
  ];

  env = {
    # Make sure `crates/gitbutler-tauri/inject-git-binaries.sh` can find our
    # target dir
    # https://github.com/gitbutlerapp/gitbutler/blob/56b64d778042d0e93fa362f808c35a7f095ab1d1/crates/gitbutler-tauri/inject-git-binaries.sh#L10C10-L10C26
    TRIPLE_OVERRIDE = rust.envVars.rustHostPlatformSpec;

    # `fetchPnpmDeps` and `pnpmConfigHook` use a specific version of pnpm, not upstream's
    COREPACK_ENABLE_STRICT = 0;

    # task tracing requires Tokio to be built with RUSTFLAGS="--cfg tokio_unstable"
    RUSTFLAGS = "--cfg tokio_unstable";

    TUBRO_BINARY_PATH = lib.getExe turbo;
    TURBO_TELEMETRY_DISABLED = 1;

    OPENSSL_NO_VENDOR = true;
    LIBGIT2_NO_VENDOR = 1;
  };

  preBuild = ''
    # force the sass npm dependency to use our own sass binary instead of the bundled one
    substituteInPlace node_modules/.pnpm/sass-embedded@*/node_modules/sass-embedded/dist/lib/src/compiler-path.js \
      --replace-fail 'compilerCommand = (() => {' 'compilerCommand = (() => { return ["${lib.getExe dart-sass}"];'

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

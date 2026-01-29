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
  fetchpatch,
}:

let
  excludeSpec = spec: [
    "--exclude"
    spec
  ];
in

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gitbutler";
  version = "0.18.3";

  src = fetchFromGitHub {
    owner = "gitbutlerapp";
    repo = "gitbutler";
    tag = "release/${finalAttrs.version}";
    hash = "sha256-N/xs63QjqEgDXAOEZpzBRl1QrwDlcYyFWSyNlku6tKw=";
  };

  # Workaround for https://github.com/NixOS/nixpkgs/issues/359340
  cargoPatches = [
    ./gix-from-crates-io.patch

    # This allows building tests with release mode instead of setting checkType = "debug";
    (fetchpatch {
      name = "remove-test-askpass-path-workaround.patch";
      url = "https://github.com/Mrmaxmeier/gitbutler/commit/34bcde7db1fa44b801428535ed4c60881d4fc4e1.patch";
      hash = "sha256-BjFSkkCdS0HxqeJNA/RmuIVzkfTZZ/kBhMDM+TwCwp4=";
    })
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

  cargoHash = "sha256-jJ8fUBv9M9aZYSgymh/FeyLOT4h4cynqi/4fnuAbIDQ=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    fetcherVersion = 2;
    hash = "sha256-R1EYyMy0oVX9G6GYrjIsWx7J9vfkdM4fLlydteVsi7E=";
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
  ++ lib.concatMap excludeSpec [
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
    # tui::get_text::tests::git_editor_takes_precedence
    "but"
    # thread 'hooks::pre_push_hook_failure' (38982) panicked at crates/gitbutler-repo/tests/hooks.rs:83:18:
    # success: Text file busy (os error 26)
    "gitbutler-repo"
  ]
  ++ [
    # These tests try connecting to a local address (192.0.2.1) and expect the
    # connection to fail in a certain way. When run on macOS with a network
    # sandbox (?) these tests fail while preparing the socket.
    # https://github.com/NixOS/nixpkgs/pull/473706#issuecomment-3734337124
    "--"
    "--skip=test_is_network_error"
  ];

  env = {
    # Make sure `crates/gitbutler-tauri/inject-git-binaries.sh` can find our
    # target dir
    # https://github.com/gitbutlerapp/gitbutler/blob/56b64d778042d0e93fa362f808c35a7f095ab1d1/crates/gitbutler-tauri/inject-git-binaries.sh#L10C10-L10C26
    TRIPLE_OVERRIDE = rust.envVars.rustHostPlatformSpec;

    # `fetchPnpmDeps` and `pnpmConfigHook` use a specific version of pnpm, not upstream's
    COREPACK_ENABLE_STRICT = 0;

    # task tracing requires Tokio to be built with RUSTFLAGS="--cfg tokio_unstable"!
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

{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  cargo-tauri,
  jq,
  makeBinaryWrapper,
  moreutils,
  nodejs,
  pkg-config,
  pnpm_10,
  fetchPnpmDeps,
  pnpmConfigHook,
  wrapGAppsHook3,

  glib-networking,
  libayatana-appindicator,
  libsoup_3,
  openssl,
  webkitgtk_4_1,

  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cc-switch";
  version = "3.16.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "farion1231";
    repo = "cc-switch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CrUoTfGAy+gi3gdcSlNyjwM2Rm4nahqDWdM6I9OQgPc=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-Vs+/KLICqciF7dnC3iRH9TFzNCtXDgOkWFPLxdwA0rE=";
  };

  postPatch = ''
    jq '
      del(.build.beforeBuildCommand) |
      .bundle.createUpdaterArtifacts = false |
      .plugins.updater.endpoints = []
    ' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    jq '.bundle.macOS.signingIdentity = null' src-tauri/tauri.conf.json | sponge src-tauri/tauri.conf.json
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # libappindicator-sys dlopens libayatana-appindicator3.so.1 at runtime; autoPatchelf can't catch it.
    substituteInPlace $cargoDepsCopy/*/libappindicator-sys-*/src/lib.rs \
      --replace-fail "libayatana-appindicator3.so.1" "${libayatana-appindicator}/lib/libayatana-appindicator3.so.1"
  '';

  cargoRoot = "src-tauri";
  buildAndTestSubdir = finalAttrs.cargoRoot;

  cargoHash = "sha256-gX32xCiVKHQ0BIIB9GyWHessIW30zbTcMZLtPJycxn8=";

  nativeBuildInputs = [
    cargo-tauri.hook
    jq
    moreutils
    nodejs
    pnpmConfigHook
    pnpm_10
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    pkg-config
    wrapGAppsHook3
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux [
    glib-networking
    libayatana-appindicator
    libsoup_3
    openssl
    webkitgtk_4_1
  ];

  # tauri-build embeds frontendDist (../dist) at compile time; populate it
  # before cargo tauri build runs (beforeBuildCommand is stripped in postPatch).
  preBuild = ''
    pnpm run build:renderer
  '';

  # Upstream Cargo.lock resolves newer tauri crates than the pinned npm packages
  # (e.g. tauri 2.10 vs @tauri-apps/api 2.8). cargo tauri build errors on that;
  # the previous cargo-only packaging already shipped this combination.
  tauriBuildFlags = [ "--ignore-version-mismatches" ];

  # Proxy startup test binds to a local address, which the darwin sandbox blocks.
  checkFlags = lib.optionals stdenv.hostPlatform.isDarwin [
    "--skip=services::provider::tests::update_current_claude_provider_syncs_live_when_proxy_takeover_detected_without_backup"
  ];

  postInstall = lib.optionalString stdenv.hostPlatform.isDarwin ''
    mkdir -p "$out/bin"
    makeWrapper "$out/Applications/CC Switch.app/Contents/MacOS/cc-switch" "$out/bin/cc-switch"
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "All-in-one assistant for Claude Code, Codex, OpenCode, Gemini CLI and other AI coding agents";
    homepage = "https://ccswitch.io";
    downloadPage = "https://github.com/farion1231/cc-switch";
    changelog = "https://github.com/farion1231/cc-switch/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    mainProgram = "cc-switch";
    maintainers = with lib.maintainers; [
      imcvampire
      kenis1108
    ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,

  coreutils,
  cargo-tauri,
  desktop-file-utils,
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
  version = "4.0.25";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "farion1231";
    repo = "cc-switch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RSe/H51Wy42wNycK8jEauAQIzUfRHGzBX0taYdqNysk=";
  };

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs)
      pname
      version
      src
      ;
    pnpm = pnpm_10;
    fetcherVersion = 3;
    hash = "sha256-W6c/GNYB1LaYYzeq4McnIw88W2/76yMrx4pVOF8GtT8=";
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

  cargoHash = "sha256-Aw6F+Rdc5Lk2X2sLf8d+Wskq+UOBAVMleB4GD0gtA24=";

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

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      --prefix PATH : "${lib.makeBinPath [ desktop-file-utils ]}"
    )
  '';

  preCheck = ''
    substituteInPlace \
      src-tauri/src/services/mcp_connectivity/tests.rs \
      src-tauri/src/session_manager/providers/mcode.rs \
      src-tauri/src/commands/misc.rs \
      --replace-warn '#!/bin/sh' '#!${stdenv.shell}' \
      --replace-warn '/usr/bin/env' '${coreutils}/bin/env' \
      --replace-warn '/bin/echo' '${coreutils}/bin/echo' \
      --replace-warn 'Command::new("/bin/bash")' 'Command::new("${stdenv.shell}")' \
      --replace-warn 'format!("{}:/usr/bin:/bin",' 'format!("{}:${lib.makeBinPath [ coreutils ]}:/usr/bin:/bin",'

    substituteInPlace src-tauri/src/commands/misc.rs \
      --replace-fail 'build_unix_launcher_script(&launch, "/bin/bash", None, &script, Some(&env_file))' 'build_unix_launcher_script(&launch, "${stdenv.shell}", None, &script, Some(&env_file))' \
      --replace-fail ".replace(\"exec '/bin/bash'\", \"exit 0 #\")" ".replace(\"exec '${stdenv.shell}'\", \"exit 0 #\")"
  '';

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

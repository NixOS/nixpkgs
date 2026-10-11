{
  lib,
  stdenv,
  rustPlatform,
  fetchpatch2,
  fetchPnpmDeps,
  cargo-tauri,
  cmake,
  perl,
  pkg-config,
  nodejs_24,
  pnpm_11,
  pnpmConfigHook,
  wrapGAppsHook3,
  makeShellWrapper,
  makeBinaryWrapper,
  rcodesign,
  libplist,
  alsa-lib,
  gtk3,
  libopus,
  libsoup_3,
  webkitgtk_4_1,
  glib-networking,
  gst_all_1,
  onnxruntime,
  sherpa-onnx,
  buzz-cli,
  buzz-acp,
  buzz-agent,
  buzz-backend-kubernetes,
  buzz-dev-mcp,
  git-credential-nostr,
  bash,
  gitMinimal,
  ffmpeg-headless,
  cacert,
  coreutils,
}:

let
  rustTarget = stdenv.hostPlatform.rust.rustcTarget;

  # Where the app and its sidecars end up.
  appDir =
    if stdenv.hostPlatform.isDarwin then
      "$out/Applications/Buzz.app/Contents/MacOS"
    else
      "$out/libexec/buzz-desktop";

  # What the app needs at runtime, on every platform. A wrapper sets it, also when
  # the macOS app is started from Finder (see postFixup).
  appEnvironment = {
    SSL_CERT_FILE = "${cacert}/etc/ssl/certs/ca-bundle.crt";
    # The shell of the built-in terminal and of agent commands.
    BUZZ_SHELL = lib.getExe bash;
    # Agent adapters (npm) run on nixpkgs' Node.js instead of the prebuilt one
    # Buzz downloads, which can't run on NixOS. Buzz accepts only Node.js 24 here.
    BUZZ_NODE_BIN_DIR = "${lib.getBin nodejs_24}/bin";
  };
  appWrapperArgs = [
    "--prefix"
    "PATH"
    ":"
    (lib.makeBinPath [
      bash
      gitMinimal
      ffmpeg-headless
    ])
  ]
  ++ lib.concatLists (
    lib.mapAttrsToList (name: value: [
      "--set-default"
      name
      value
    ]) appEnvironment
  );

  gstreamerPlugins = with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
    # transcode elements for WebKit's MediaRecorder (voice notes)
    gst-plugins-bad
    gst-libav
  ];

  # Keep the GStreamer plugin registry per user and per target, so it is not
  # shared with (and corrupted by) other GStreamer applications.
  registrySetup = ''
    if [[ -z "''${GST_REGISTRY_1_0:-}" ]]; then
      cacheHome="''${XDG_CACHE_HOME:-''${HOME:?HOME must be set}/.cache}"
      export GST_REGISTRY_1_0="$cacheHome/buzz/gstreamer-1.0/registry-${rustTarget}.bin"
      ${lib.getExe' coreutils "mkdir"} -p "$cacheHome/buzz/gstreamer-1.0"
    fi
  '';
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buzz-desktop";
  # The Buzz packages are built at the same desktop release (see buzz-cli); the
  # app bundles their binaries, so it shares their source.
  version = lib.removePrefix "desktop-v" buzz-cli.src.tag;

  __structuredAttrs = true;
  strictDeps = true;

  inherit (buzz-cli) src;

  cargoRoot = "desktop/src-tauri";
  buildAndTestSubdir = "desktop/src-tauri";
  cargoHash = "sha256-oPJNW3eQfZc1oIYWNmAqpc7/F6NnMePbfQBG/kMQ1UU=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    # Upstream's package.json pins pnpm 11 (`packageManager`).
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-qxtgbCeivfpAQg2+JOUGCQo7agf0GAARvLle89jFzu4=";
  };
  pnpmWorkspaces = [ "buzz" ];

  patches = [
    # BUZZ_NODE_BIN_DIR: use a packager-supplied Node.js for agent adapters
    # instead of the prebuilt one Buzz downloads, which can't run on NixOS.
    # https://github.com/block/buzz/pull/7153
    (fetchpatch2 {
      name = "support-packager-supplied-node-runtime.patch";
      url = "https://github.com/block/buzz/commit/87bc16dceb0c62777b636a1ab1d5db0d21591419.patch";
      hash = "sha256-x2YIb4U1+6JU/UVymqq2oqdDehnUuVztXmyGs73RNvM=";
    })
    (fetchpatch2 {
      name = "allow-node-override-without-bundled-artifact.patch";
      url = "https://github.com/block/buzz/commit/796978b875b51ec81013958e156e532c57563e89.patch";
      hash = "sha256-POHR0stYJh2D0Efv6ENNbq1W5fDiFk9jOv5JfhKj5XI=";
    })
    # From sebfried's buzz-desktop packaging (NixOS/nixpkgs#549345):
    # env!("CARGO_MANIFEST_DIR") survives --remap-path-prefix, so release builds
    # would embed and search the temporary build directory for sidecars.
    # Not upstream yet; block/buzz#2655 only reorders that search in release builds.
    ./dev-only-sidecar-discovery.patch
    # Nixpkgs runs the tests in the release profile, where two migration helpers
    # these tests call are compiled out. Specific to that, so not upstreamed.
    ./test-cfg-migration-helpers.patch
  ];

  postPatch = ''
    # The sidecars Buzz bundles, from the packages built at this release.
    for executable in ${
      lib.escapeShellArgs (
        map lib.getExe [
          buzz-cli
          buzz-acp
          buzz-agent
          buzz-backend-kubernetes
          buzz-dev-mcp
          git-credential-nostr
        ]
      )
    }; do
      install -Dm755 "$executable" \
        "desktop/src-tauri/binaries/$(basename "$executable")-${rustTarget}"
    done

    # Link against sherpa-onnx from nixpkgs instead of downloading prebuilt static libraries.
    # Every dependent must opt out of the default `static` feature, or Cargo unifies both.
    for manifest in desktop/src-tauri/Cargo.toml crates/buzz-voice/Cargo.toml; do
      substituteInPlace "$manifest" \
        --replace-fail 'sherpa-onnx = "1.12"' \
          'sherpa-onnx = { version = "1.12", default-features = false, features = [ "shared" ] }'
    done

    # Process-group tests start /bin/sleep, which the build sandbox lacks.
    substituteInPlace desktop/src-tauri/src/managed_agents/runtime/tests.rs \
      --replace-fail /bin/sleep ${lib.getExe' coreutils "sleep"}
  '';

  nativeBuildInputs = [
    cmake
    perl
    pkg-config
    cargo-tauri.hook
    nodejs_24
    pnpm_11
    pnpmConfigHook
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
    makeShellWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
    rcodesign
  ];

  buildInputs = [
    libopus
    onnxruntime
    sherpa-onnx
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux (
    [
      alsa-lib
      gtk3
      libsoup_3
      webkitgtk_4_1
      glib-networking
    ]
    ++ gstreamerPlugins
  );

  env = {
    AWS_LC_SYS_CMAKE_BUILDER = 1;
    SHERPA_ONNX_LIB_DIR = "${lib.getLib sherpa-onnx}/lib";
  };

  # cmake is only used by dependency build scripts
  dontUseCmakeConfigure = true;

  cargoBuildFlags = [
    "--package"
    "buzz-desktop"
  ];

  doNotPostBuildInstallCargoBinaries = true;
  tauriBuildFlags = [
    "--no-sign"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Tauri otherwise declares an older macOS than Nixpkgs builds for.
    "--config"
    (builtins.toJSON { bundle.macOS.minimumSystemVersion = stdenv.hostPlatform.darwinMinVersion; })
  ];

  # Panic messages would otherwise carry the temporary build directory.
  preBuild = ''
    export RUSTFLAGS="--remap-path-prefix=$NIX_BUILD_TOP=/build ''${RUSTFLAGS:-}"
    export NIX_CFLAGS_COMPILE="-ffile-prefix-map=$NIX_BUILD_TOP=/build ''${NIX_CFLAGS_COMPILE:-}"
  '';
  disallowedReferences = [ finalAttrs.src ];

  nativeCheckInputs = [
    # Many tests build HTTP clients, which need the system CA certificates.
    cacert
    gitMinimal
    perl
  ];
  # The tests start servers on 127.0.0.1.
  __darwinAllowLocalNetworking = true;

  # These tests run /bin/bash, /usr/bin/env or /usr/bin/true, use a
  # `#!/usr/bin/env node` script, or run `env`/`true` with PATH cleared, and
  # none of these exist in the build sandbox.
  checkFlags = map (test: "--skip=${test}") [
    "commands::agent_auth::tests::auth_command_uses_augmented_path_for_node_adapter"
    "commands::agent_discovery::tests::test_composed_path_survives_a_profile_that_clears_it"
    "commands::agent_discovery::tests::test_install_shell_pipeline_status_follows_left_side"
    "managed_agents::agent_env::tests::baked_defaults_do_not_override_record_provider_written_after"
    "managed_agents::agent_env::tests::buzz_agent_provider_defaults_empty_in_oss_build"
    "managed_agents::config_bridge::effort::tests::cmd_tests::production_sequence_custom_inherited_acp_sentinel_survives"
    "managed_agents::config_bridge::effort::tests::cmd_tests::production_sequence_custom_inherited_goose_key_survives"
    "managed_agents::config_bridge::effort::tests::cmd_tests::production_sequence_custom_passthrough_survives"
    "managed_agents::config_bridge::effort::tests::cmd_tests::production_sequence_goose_inherited_collision_resolved_in_child"
    "managed_agents::discovery::tests::codex_version::probe_codex_acp_version_uses_augmented_path_for_env_shebang_interpreter"
    "managed_agents::readiness::cli_probe::tests::login_probe_uses_augmented_path_for_env_shebang_interpreter"
    "managed_agents::runtime::tests::kill_stale_live_pair_is_not_touched"
    "managed_agents::spawn_snapshot::diff::tests::no_sentinel_reaches_the_owning_process_debug_output"
    # Flaky: runs a provider script it just wrote while a test running in
    # parallel may still hold it open ("Text file busy").
    "managed_agents::backend::tests::provider_deploy_refuses_mismatch_before_sending_agent_secret"
  ];

  # Upstream's update plugin is only compiled in when the build sets an update
  # endpoint and key; make sure a Nix build never ships it. Then check what the
  # desktop integration and the media features rely on.
  doInstallCheck = true;
  nativeInstallCheckInputs = lib.optionals stdenv.hostPlatform.isDarwin [ libplist ];
  installCheckPhase = ''
    runHook preInstallCheck
    app=${appDir}/${if stdenv.hostPlatform.isDarwin then ".buzz-desktop-wrapped" else "buzz-desktop"}
    if grep -q 'tauri-plugin-updater/' "$app"; then
      echo "updater plugin is linked into the application" >&2
      exit 1
    fi
    "${appDir}/buzz" --help > /dev/null
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # buzz:// links open the app.
    grep -q 'x-scheme-handler/buzz' $out/share/applications/Buzz.desktop
    find $out/share/icons -type f | grep -q .
    # Voice notes, media playback and the camera.
    export GST_PLUGIN_SYSTEM_PATH_1_0=${lib.makeSearchPath "lib/gstreamer-1.0" gstreamerPlugins}
    export GST_REGISTRY_1_0=$TMPDIR/gst-registry.bin
    for element in playbin3 mpg123audiodec v4l2src avdec_h264; do
      ${lib.getExe' gst_all_1.gstreamer "gst-inspect-1.0"} $element > /dev/null
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    rcodesign print-signature-info "$app" > signature-info
    grep -Fq 'RUNTIME' signature-info
    grep -Fq 'com.apple.security.cs.disable-library-validation' signature-info
    # Usage descriptions for the permission prompts, and buzz:// links.
    plistutil -f xml -i $out/Applications/Buzz.app/Contents/Info.plist -o Info.plist
    for key in NSMicrophoneUsageDescription NSCameraUsageDescription NSLocalNetworkUsageDescription; do
      grep -Fq "<key>$key</key>" Info.plist
    done
    grep -A3 -F '<key>CFBundleURLSchemes</key>' Info.plist | grep -Fq '<string>buzz</string>'
  ''
  + ''
    runHook postInstallCheck
  '';

  postInstall =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      # The app finds its sidecars next to its own executable. Keep them out of
      # $out/bin so they don't collide with the standalone buzz-cli, buzz-agent, etc.
      mkdir -p ${appDir}
      mv $out/bin/* ${appDir}/

      substituteInPlace $out/share/applications/Buzz.desktop \
        --replace-fail 'Categories=' 'Categories=Network;Chat;InstantMessaging;'
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/bin
      ln -s ../Applications/Buzz.app/Contents/MacOS/buzz-desktop $out/bin/buzz-desktop
    '';

  # Wrap only the app (not the sidecars), in one shell wrapper; see postFixup.
  dontWrapGApps = true;

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      ${lib.escapeShellArgs appWrapperArgs}
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${lib.makeSearchPath "lib/gstreamer-1.0" gstreamerPlugins}"
    )
  '';

  postFixup =
    # A shell wrapper because the registry path depends on $HOME at runtime (`--run`).
    lib.optionalString stdenv.hostPlatform.isLinux ''
      makeShellWrapper "${appDir}/buzz-desktop" "$out/bin/buzz-desktop" \
        "''${gappsWrapperArgs[@]}" \
        --run ${lib.escapeShellArg registrySetup}
    ''
    # A binary wrapper inside the bundle stays the app's executable, so it also
    # applies when the app is started from Finder. Then ad-hoc sign the bundle like
    # upstream's release: the hardened runtime with upstream's entitlements
    # (camera, microphone, loading libraries from the Nix store) on the wrapped
    # program. The wrapper and the sidecars keep plain
    # ad-hoc signatures, so they load their Nix-store libraries without entitlements.
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapProgram "${appDir}/buzz-desktop" ${lib.escapeShellArgs appWrapperArgs}
      rcodesign sign \
        --code-signature-flags Contents/MacOS/.buzz-desktop-wrapped:runtime \
        --entitlements-xml-file Contents/MacOS/.buzz-desktop-wrapped:${finalAttrs.src}/desktop/src-tauri/Entitlements.plist \
        $out/Applications/Buzz.app
    '';

  # Updates all Buzz packages to the newest desktop release.
  passthru = { inherit (buzz-cli) updateScript; };

  meta = {
    description = "Workspace where humans and AI agents build together";
    longDescription = ''
      Buzz is a workspace for team chat, git hosting and AI agents, built on
      Nostr. Agents on `PATH` are used as they are, so install them
      from nixpkgs: `goose-cli`, `claude-agent-acp` (with `claude-code`) or
      `codex-acp` (with `codex`).
    '';
    homepage = "https://github.com/block/buzz";
    changelog = "https://github.com/block/buzz/releases/tag/desktop-v${finalAttrs.version}";
    license = lib.licenses.asl20;
    mainProgram = "buzz-desktop";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

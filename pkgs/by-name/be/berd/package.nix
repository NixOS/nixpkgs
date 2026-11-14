{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchPnpmDeps,
  runCommand,
  cargo-tauri,
  cmake,
  pkg-config,
  nodejs_24,
  nodejs-slim_24,
  pnpm_10,
  pnpmConfigHook,
  wrapGAppsHook3,
  makeBinaryWrapper,
  alsa-lib,
  aws-lc,
  bashNonInteractive,
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
  glib-networking,
  gst_all_1,
  onnxruntime,
  sherpa-onnx,
  sqlite,
  goose-cli,
  block-catch,
  cacert,
  coreutils,
  swift,
  swiftpm,
  xcbuild,
  writableTmpDirAsHomeHook,
  nix-update-script,
}:

let
  # Upstream pins pnpm 10 (`packageManager` in package.json) and builds with Node.js 24
  # (node-version in .github/workflows/release.yml).
  pnpm = pnpm_10.override {
    nodejs-slim = nodejs-slim_24;
  };

  rustTarget = stdenv.hostPlatform.rust.rustcTarget;

  # WebKit plays Berd's sounds and voice audio through GStreamer and aborts without an audio
  # sink (the AppImage variant of this is block/berd#195).
  skipArgs =
    tests:
    lib.optionalString (tests != [ ]) (" -- " + lib.concatMapStringsSep " " (t: "--skip ${t}") tests);

  # Sidecars built from the same Cargo workspace (scripts/prepare-berdctl-sidecar.sh); Berd Call,
  # the voice-call CLI, ships with the app on macOS only.
  sidecarCrates = [
    "berdctl"
    "berd-monitor"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [ "berd-call" ];

  gstreamerPlugins = with gst_all_1; [
    gstreamer
    gst-plugins-base
    gst-plugins-good
  ];

  # Tests that can't work in the build sandbox
  # Set an ACL with macOS's /bin/chmod, which the sandbox doesn't allow
  berdctlPluginTestSkips = lib.optionals stdenv.hostPlatform.isDarwin [
    "discovery::tests::write_removes_inherited_macos_acls_before_publishing"
  ];
  berdctlTestSkips = lib.optionals stdenv.hostPlatform.isDarwin [
    "extended_acl_on_file_or_directory_is_rejected_despite_private_modes"
  ];
  berdCallTestSkips =
    lib.optionals (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isAarch64) [
      # They expect an empty stderr, but onnxruntime's CPU detection warns there without /sys.
      "global_help_is_successful_and_lists_only_supported_commands"
      "command_help_is_available_in_prefix_and_suffix_forms"
      "version_is_successful_and_machine_readable_as_one_line"
      "suffix_help_after_a_complete_boolean_option_is_successful"
      "local_model_management_is_process_stable_without_network_or_root_creation"
      "unsupported_platform_management_contract_is_process_stable"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Reads the system's Siri voice catalog
      "siri::tests::exact_uninstalled_voice_is_rejected_without_synthesis"
      # Compiles and runs a CoreAudio AudioUnit
      "native_health_latches_offline_render_errors_while_engine_is_running"
    ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "berd";
  version = "0.6.5";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "block";
    repo = "berd";
    tag = "v${finalAttrs.version}";
    hash = "sha256-dGpMXPE9qV4rrpdO2VsHeMSoaUKUQCAKeoIhliTC81s=";
  };

  cargoRoot = "src-tauri";
  buildAndTestSubdir = "src-tauri";
  cargoHash = "sha256-aSy2R3Gr1ZIImrHjaqlvIs4Pm+cV1A8RzxPJqxnG8Ks=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    inherit pnpm;
    fetcherVersion = 5;
    hash = "sha256-CzaBe2MbZnMbBNH0nONVWHSfcq/r19nSsenZLuBr1b4=";
  };

  postPatch = ''
    # Link against sherpa-onnx from nixpkgs instead of downloading prebuilt static libraries
    # in the build script. Every dependent must opt out of the default `static` feature, or
    # Cargo unifies both (block/berd#449). The Rust bindings (sherpa-onnx-sys 1.12.40) were
    # checked against the 1.13 C API header for the structs Berd uses (OfflineRecognizer, Wave,
    # LinearResampler).
    substituteInPlace src-tauri/Cargo.toml \
      --replace-fail 'berd-call = { path = "crates/berd-call", features = ["static"] }' \
        'berd-call = { path = "crates/berd-call", default-features = false, features = ["shared"] }'
    substituteInPlace src-tauri/crates/berd-call/Cargo.toml \
      --replace-fail 'default = ["static"]' 'default = []'

    # Tauri checks that every `externalBin` exists, with the target triple appended, at build
    # time. Upstream's release builds Goose from the commit in goose-backend.lock.json; this
    # package uses nixpkgs' goose-cli instead (Berd only needs `goose serve`, see GOOSE_BIN in
    # upstream's README), so Goose stays maintained in one place. Which goose releases a Berd
    # release works with: block/berd#456.
    mkdir -p src-tauri/binaries
    ln -s ${lib.getExe goose-cli} src-tauri/binaries/goosed-${rustTarget}

    # Test helpers the sandbox doesn't have at their FHS paths
    substituteInPlace src-tauri/crates/berd-call/src/host_session.rs \
      --replace-fail '"/bin/cat"' '"${lib.getExe' coreutils "cat"}"' \
      --replace-fail '"/bin/sleep"' '"${lib.getExe' coreutils "sleep"}"' \
      --replace-fail '"/usr/bin/true"' '"${lib.getExe' coreutils "true"}"'
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # Catch (block/catch) is macOS-only; upstream's script stages its own stub on other platforms.
    bash scripts/prepare-catch-sidecar.sh ${rustTarget}
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    # Upstream's release downloads a prebuilt Catch (block/catch) for the global shortcut. 0.6.5
    # expects Catch 0.5.1 (CATCH_VERSION in scripts/prepare-catch-sidecar.sh), as in block-catch.
    ln -s ${lib.getExe block-catch} src-tauri/binaries/catch-${rustTarget}

    # Unless it runs from an Applications folder, Berd asks at start (until "Do not ask again") to
    # move itself into /Applications; accepting copies the bundle out of the Nix store, where
    # updates never reach it.
    # Skip the prompt as upstream does for debug builds; nix-darwin or Home Manager link the
    # app into an Applications folder. Build switch asked for in block/berd#457.
    substituteInPlace src-tauri/src/services/installer_media.rs \
      --replace-fail 'if cfg!(debug_assertions) {' 'if true {'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    cargo-tauri.hook
    nodejs_24
    pnpm
    pnpmConfigHook
    makeBinaryWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ wrapGAppsHook3 ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # build.rs compiles the AirPods bridge (a SwiftPM package) through swift-rs.
    swift
    swiftpm
    xcbuild
    writableTmpDirAsHomeHook
  ];

  buildInputs = [
    aws-lc
    # shared sherpa-onnx links against onnxruntime
    onnxruntime
    sherpa-onnx
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux (
    [
      # patchShebangs needs sh in the host inputs for the Catch stub (strictDeps)
      bashNonInteractive
      alsa-lib
      gtk3
      libsoup_3
      webkitgtk_4_1
      glib-networking
    ]
    ++ gstreamerPlugins
  );

  env = {
    SHERPA_ONNX_LIB_DIR = "${lib.getLib sherpa-onnx}/lib";
    # Renderer gates as in upstream's public builds (`just bundle`): no Block sign-in gate,
    # bring-your-own-key providers on.
    VITE_AUTH_GATE = "0";
    VITE_BYO_KEY_PROVIDERS = "1";
    VITE_APP_VERSION = finalAttrs.version;
    BERD_APP_VERSION = finalAttrs.version;
    # Updates come from nixpkgs. Without the release overlay (tauri.release.conf.json) there is
    # no updater public key, so the backend never registers the updater; this hides its UI.
    VITE_UPDATER_ENABLED = "false";
    # As in upstream's release: telemetry stays off until the user opts in (TELEMETRY.md).
    VITE_ENVIRONMENT = "production";
    # `pnpm build` type-checks the whole frontend; upstream's CI gives Node the same heap (ci.yml).
    NODE_OPTIONS = "--max-old-space-size=4096";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # swift-rs asks this clang for its compiler-rt directory (default /usr/bin/clang).
    SWIFT_RS_CLANG = "${stdenv.cc}/bin/clang";
  };

  # cmake is only used by dependency build scripts
  dontUseCmakeConfigure = true;

  buildFeatures = [
    # The app-control server the bundled berdctl CLI talks to; on in upstream releases.
    "berdctl"
    # Don't download Node.js and install the Claude Code/Codex ACP bridges at startup. Agents
    # from nixpkgs on PATH (e.g. claude-agent-acp, codex-acp) work; the installers in Settings
    # stay available and run only when the user asks.
    "no-managed-acp-tools"
    # Don't offer to symlink berdctl into /usr/local/bin; it is in $out/bin.
    "no-bb-cli-install"
  ];

  preBuild = ''
    # The frontend imports the vendored @aaif/goose-sdk from its build output (upstream's
    # `just setup` builds it before `pnpm build`).
    pnpm --filter @aaif/goose-sdk build:ts

    (
      cd src-tauri
      cargo build --release --offline --frozen -j $NIX_BUILD_CORES --target ${rustTarget} \
        ${lib.concatMapStringsSep " " (crate: "-p ${crate}") sidecarCrates} \
        ${lib.optionalString stdenv.hostPlatform.isDarwin "--features berd-call/shared"}
    )
    for executable in ${toString sidecarCrates}; do
      install -Dm755 "src-tauri/target/${rustTarget}/release/$executable" \
        "src-tauri/binaries/$executable-${rustTarget}"
    done
  '';

  tauriBuildFlags = [ "--no-sign" ];

  # The telemetry tests build a reqwest client, which needs CA certificates even for the local
  # test gateway.
  nativeCheckInputs = [ cacert ];
  # The berdctl server tests listen on 127.0.0.1.
  __darwinAllowLocalNetworking = true;

  # The Rust test lanes of upstream's `just tauri-test`, which its CI runs on ubuntu-latest in
  # the dev profile, with the sidecars and resources left out of the Tauri config like there.
  # The frontend tests (`just test`) run on macOS only upstream.
  checkPhase = ''
    runHook preCheck

    export TAURI_CONFIG='{"bundle":{"externalBin":[],"resources":[]}}'
    (
      cd src-tauri
      for args in \
        "-p tauri-plugin-berdctl --features server${skipArgs berdctlPluginTestSkips}" \
        "-p berdctl${skipArgs berdctlTestSkips}" \
        "-p berd-call --features shared${skipArgs berdCallTestSkips}" \
        "--lib services::acp::goose_serve::tests::storage_identity_guard" \
        "--lib services::goose_config::tests" \
        "--lib commands::message_search::tests" \
        "--lib telemetry" \
        "--lib --features block-telemetry-enforced telemetry" \
        "--lib --features block-skill-discovery skill_marketplace"; do
        # sherpa-onnx-sys copies its libraries from the store, read-only, next to the test
        # binaries; a lane that rebuilds it with other features must be able to replace them.
        chmod -R u+w "$CARGO_TARGET_DIR"
        # shellcheck disable=SC2086 # word splitting is the point
        cargo test --offline --frozen -j $NIX_BUILD_CORES --target ${rustTarget} --no-fail-fast $args
      done
    )

    runHook postCheck
  '';

  postInstall = lib.optionalString stdenv.hostPlatform.isLinux ''
    # The app finds its sidecars next to its own executable and its resources (distro/,
    # runtime-config.json, sounds) at ../lib/Berd relative to the executable's directory;
    # without that directory Tauri falls back to /usr/lib/Berd. Keep all of it together under
    # libexec, so $out/bin holds only `berd` and `berdctl` and not goosed, catch and
    # berd-monitor.
    mkdir -p $out/libexec/berd/bin
    mv $out/bin/* $out/libexec/berd/bin/
    mv $out/lib $out/libexec/berd/lib

    # Run the wrapper; upstream sets no category (block/berd#450).
    substituteInPlace $out/share/applications/Berd.desktop \
      --replace-fail 'Exec=Berd' 'Exec=berd' \
      --replace-fail 'Categories=' 'Categories=Development;Utility;'
  '';

  # Wrap only the app, not the sidecars; see postFixup. No SSL_CERT_FILE: Berd and goosed find
  # the system CA store, which includes certificates added with security.pki.
  dontWrapGApps = true;

  postFixup =
    lib.optionalString stdenv.hostPlatform.isLinux ''
      makeWrapper $out/libexec/berd/bin/Berd $out/bin/berd "''${gappsWrapperArgs[@]}"
      # berdctl talks to a running Berd; agents started by Berd get it via BERDCTL_BIN.
      ln -s ../libexec/berd/bin/berdctl $out/bin/berdctl
    ''
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      mkdir -p $out/bin
      # Not a symlink: Tauri refuses to start on macOS when current_exe() goes through one.
      makeWrapper $out/Applications/Berd.app/Contents/MacOS/Berd $out/bin/berd
      ln -s ../Applications/Berd.app/Contents/MacOS/berdctl $out/bin/berdctl
    '';

  passthru = {
    tests.sidecars =
      let
        # Next to the executable, and Tauri's resource dir.
        layout =
          if stdenv.hostPlatform.isDarwin then
            {
              bin = "Applications/Berd.app/Contents/MacOS";
              resources = "Applications/Berd.app/Contents/Resources";
            }
          else
            {
              bin = "libexec/berd/bin";
              resources = "libexec/berd/lib/Berd";
            };
        bin = "${finalAttrs.finalPackage}/${layout.bin}";
        resources = "${finalAttrs.finalPackage}/${layout.resources}";
      in
      runCommand "berd-sidecars-test" { } ''
        # goose writes its logs under HOME even for --help.
        export HOME=$(mktemp -d)
        for executable in Berd goosed ${toString sidecarCrates} catch; do
          test -x ${bin}/$executable
        done
        test -f ${resources}/runtime-config.json
        # The updater registers only with a public key in the config, and release channels come
        # from this catalog; both are only in upstream's release overlay.
        if [ -e ${resources}/release-channels.json ]; then
          echo "release-channels.json is bundled: the updater would be active" >&2
          exit 1
        fi
        ${bin}/goosed serve --help | grep -q -- '--allowed-origin'
        ${finalAttrs.finalPackage}/bin/berdctl --help | grep -q 'Control the Berd desktop app'
        ${bin}/berd-monitor --help | grep -q 'Berd session'
        touch $out
      '';
    updateScript = nix-update-script { };
  };

  meta = {
    description = "Desktop app for working with AI agents, built on Goose";
    homepage = "https://github.com/block/berd";
    changelog = "https://github.com/block/berd/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "berd";
    maintainers = [ lib.maintainers.kleinbem ];
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

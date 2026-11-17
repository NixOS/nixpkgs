{
  lib,
  stdenv,
  rustPlatform,
  runCommand,
  fetchFromGitHub,
  fetchPnpmDeps,
  cargo-tauri,
  cmake,
  pkg-config,
  nodejs_24,
  pnpm_11,
  pnpmConfigHook,
  wrapGAppsHook3,
  makeShellWrapper,
  makeBinaryWrapper,
  rcodesign,
  dbus,
  aws-lc,
  sqlite,
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
  glib-networking,
  gst_all_1,
  goose-cli,
  buzz-cli,
  skippy-native-runtime,
  rocmPackages,
  jq,
  cacert,
  bash,
  coreutils,
  perl,
  procps,
  curl,
  gitMinimal,
  ffmpeg-headless,
  nix-update-script,
}:

let
  rustTarget = stdenv.hostPlatform.rust.rustcTarget;

  # The app's Goose agent. Upstream downloads a pinned goose-acp during the
  # build; nixpkgs' `goose acp` runs the same server, at nixpkgs' goose version.
  goose-acp = runCommand "goose-acp-${goose-cli.version}" {
    nativeBuildInputs = [ makeBinaryWrapper ];
  } "makeWrapper ${lib.getExe goose-cli} $out/bin/goose-acp --add-flags acp";

  # Shared compute (the bundled MeshLLM plugin) runs models with this llama.cpp
  # runtime instead of downloading upstream's prebuilt ones. As for mesh-llm, its
  # GPU backend follows the nixpkgs config.
  runtime = skippy-native-runtime;
  meshRuntimeEnvironment = runtime.hostEnvironment // {
    MESH_LLM_NATIVE_RUNTIME_BUNDLE_DIR = "${runtime}/share/mesh-llm/runtimes";
  };

  # Fallbacks only, the user's own tools come first. Plugins run git (projects),
  # ffmpeg (media uploads) and node (the Pi agent) from PATH, and the Claude Code
  # and Codex plugin scripts download their agents with curl and check them with
  # coreutils' sha256sum.
  runtimePath = lib.makeBinPath (
    [
      gitMinimal
      ffmpeg-headless
      nodejs_24
      curl
      coreutils
    ]
    # MeshLLM finds AMD GPUs and their VRAM with rocm-smi.
    ++ lib.optionals (runtime.backend == "rocm") [ rocmPackages.rocm-smi ]
  );

  # No SSL_CERT_FILE on Linux: the app and its agents use the system CA store,
  # which includes certificates added with security.pki.
  appWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    runtimePath
  ]
  ++ lib.concatLists (
    lib.mapAttrsToList (name: value: [
      "--set-default"
      name
      value
    ]) meshRuntimeEnvironment
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
      export GST_REGISTRY_1_0="$cacheHome/buzz-app/gstreamer-1.0/registry-${rustTarget}.bin"
      ${lib.getExe' coreutils "mkdir"} -p "$cacheHome/buzz-app/gstreamer-1.0"
    fi
  '';

  # Where Tauri resolves the app's resources (bundled goose-acp): next to the
  # executable's ../lib/<productName> on Linux, Contents/Resources on macOS.
  resourceDir =
    if stdenv.hostPlatform.isDarwin then
      "$out/Applications/Buzz.app/Contents/Resources"
    else
      "$out/lib/Buzz Foundation";
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "buzz-app";
  version = "1.0.6";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz-app";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RsvYf36f2Wl0f870BWHNVTekZ8NJdFaBuQc0XdEHmcI=";
  };

  buildAndTestSubdir = "src-tauri";
  cargoPatches = [
    # MeshLLM 0.79 -> 0.80 (versions and revs only), matching nixpkgs'
    # skippy-native-runtime ABI; drop once buzz-app pins 0.80
    # (https://github.com/block/buzz-app/pull/4209).
    ./mesh-llm-0.80.patch
  ];
  cargoHash = "sha256-QvujrRwtaK6XXnYnvKhFkIpfoDHu03PCPjVmgmWi1OQ=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    # Upstream's package.json pins pnpm 11 (`packageManager`).
    pnpm = pnpm_11;
    fetcherVersion = 5;
    hash = "sha256-az8tuM9xtIoGoZ1aJ2/rtgrNJsiCE+iMYtCc4MeKmDI=";
  };

  patches = [
    # On Linux the app registers its running binary as the buzz:// handler on
    # every start; under Nix that is the unwrapped, version-specific store path.
    # The .desktop file declares the scheme instead. Nix-only: .deb and AppImage
    # launch a stable path.
    ./no-linux-scheme-self-registration.patch
    # The app links ~/.local/bin/buzz to its bundled CLI (block/buzz-app#3386),
    # a store path without a GC root under Nix; nixpkgs ships buzz-cli instead.
    # Nix-only: .deb and AppImage installs have a stable path or are skipped.
    ./no-cli-link.patch
  ];

  postPatch = ''
    install -Dm755 ${goose-acp}/bin/goose-acp src-tauri/resources/bin/goose-acp
    # Upstream bundles the buzz CLI for people and agents; nixpkgs' buzz-cli
    # can be older than the block/buzz revision upstream builds it from.
    install -Dm755 ${lib.getExe buzz-cli} src-tauri/resources/bin/buzz

    # Test fixtures run tools from /bin and /usr/bin, which the build sandbox
    # lacks; https://github.com/block/buzz-app/pull/1779 runs them from PATH.
    substituteInPlace src-tauri/src/test_executable.rs \
      --replace-fail '"/bin/cp"' '"${lib.getExe' coreutils "cp"}"'
    substituteInPlace src-tauri/src/relay/media_preparation.rs \
      --replace-fail '"/bin/kill"' '"${lib.getExe' coreutils "kill"}"'
    substituteInPlace src-tauri/src/host_command.rs \
      --replace-fail /usr/bin/head ${lib.getExe' coreutils "head"} \
      --replace-fail /usr/bin/tr ${lib.getExe' coreutils "tr"}
    substituteInPlace src-tauri/src/host_process/claude_hooks.rs \
      --replace-fail '"/bin/sleep"' '"${lib.getExe' coreutils "sleep"}"'
    substituteInPlace src-tauri/src/host_process/tests.rs \
      --replace-fail '"/usr/bin/mkfifo"' '"${lib.getExe' coreutils "mkfifo"}"'
    substituteInPlace crates/agent-command/tests/discovery.rs \
      --replace-fail '"/bin/bash"' '"${lib.getExe bash}"' \
      --replace-fail '"/usr/bin/touch"' '"${lib.getExe' coreutils "touch"}"' \
      --replace-fail '"/usr/bin/true"' '"${lib.getExe' coreutils "true"}"'
    # The same for a git shim; https://github.com/block/buzz-app/pull/2417
    # prints the variable with a shell builtin instead.
    substituteInPlace crates/plugin-manager/tests/fixtures/ssh-auth-sock.sh \
      --replace-fail /usr/bin/printenv ${lib.getExe' coreutils "printenv"}
  ''
  # MeshLLM uses a runtime only when it was built for exactly its runtime
  # release and skippy ABI, and silently downloads one otherwise.
  + ''
    runtimeVersion=$(cat "$cargoDepsCopy"/*/skippy-native-runtime-*/RUNTIME_VERSION)
    skippyAbi=$(sed -n 's/^pub const ABI_VERSION_[A-Z]*: u32 = \([0-9]*\);/\1/p' "$cargoDepsCopy"/*/skippy-ffi-*/src/lib.rs | paste -sd .)
    manifests=(${runtime}/share/mesh-llm/runtimes/*/manifest.json)
    if [[ -z $runtimeVersion || -z $skippyAbi || ''${#manifests[@]} -eq 0 ]]; then
      echo "can't read the runtime release, skippy ABI or runtime manifest" >&2
      exit 1
    fi
    for manifest in "''${manifests[@]}"; do
      jq -e --arg v "$runtimeVersion" --arg a "$skippyAbi" \
        '.runtime.release_version == $v and .runtime.skippy_abi == $a' "$manifest" > /dev/null || {
        echo "$manifest is not for runtime $runtimeVersion, skippy ABI $skippyAbi;" \
          "move mesh-llm-0.80.patch to skippy-native-runtime's MeshLLM release" >&2
        exit 1
      }
    done
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # The notification tests start `dbus-daemon --session`, which reads
    # /etc/dbus-1/session.conf; the sandbox has none.
    substituteInPlace src-tauri/src/notifications/linux/tests.rs \
      --replace-fail '"--session",' '"--config-file=${dbus}/share/dbus-1/session.conf",'
  '';

  nativeBuildInputs = [
    cmake
    pkg-config
    cargo-tauri.hook
    nodejs_24
    pnpm_11
    pnpmConfigHook
    jq
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
    makeShellWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
    rcodesign
  ];

  # The cargo hooks link system libraries: AWS-LC for rustls (aws-lc-sys
  # 0.42+) and SQLite, also where rusqlite asks for its bundled copy.
  buildInputs = [
    aws-lc
    sqlite
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux (
    [
      gtk3
      libsoup_3
      webkitgtk_4_1
      glib-networking
    ]
    ++ gstreamerPlugins
  );

  env = {
    # Automatic key backup, as in upstream's release builds
    # (.github/workflows/release.yml); it runs only after the user turns it on.
    BUZZ_NSEC_BACKUP_SERVICE_URL = "https://app.builderlab.xyz/api/goose";
    BUZZ_NSEC_BACKUP_NAMESPACE = "backup/bb-public/production";
  };

  # cmake is only used by dependency build scripts
  dontUseCmakeConfigure = true;

  cargoBuildFlags = [
    "--package"
    "Buzz"
  ];

  tauriBuildFlags = [
    "--no-sign"
    "--config"
    (builtins.toJSON (
      {
        # tauri.conf.json carries an older version; upstream's release build
        # passes the tag's (scripts/candidate-version.mjs).
        inherit (finalAttrs) version;
        # Upstream's command also downloads a prebuilt goose-acp and builds the
        # buzz CLI from git, which postPatch provides instead. These let packagers
        # pass their own: https://github.com/block/buzz-app/pull/1781 (goose-acp),
        # https://github.com/block/buzz-app/pull/2376 (buzz).
        build.beforeBuildCommand = "node scripts/build-agent-command.mjs && pnpm build";
      }
      // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
        # Tauri otherwise declares an older macOS than Nixpkgs builds for.
        bundle.macOS.minimumSystemVersion = stdenv.hostPlatform.darwinMinVersion;
      }
    ))
  ];

  # Panic messages would otherwise carry the temporary build directory. Setting
  # RUSTFLAGS hides the target rustflags Nixpkgs passes, so keep its frame pointers.
  preBuild = ''
    export RUSTFLAGS="--remap-path-prefix=$NIX_BUILD_TOP=/build -Cforce-frame-pointers=yes ''${RUSTFLAGS:-}"
    export NIX_CFLAGS_COMPILE="-ffile-prefix-map=$NIX_BUILD_TOP=/build ''${NIX_CFLAGS_COMPILE:-}"
  '';
  # buzzodz, upstream's plugin manager CLI, shares the app's plugin format and
  # profiles, so it ships with the app instead of as its own package.
  postBuild = ''
    cargo build -j $NIX_BUILD_CORES --offline --frozen --release \
      --target ${stdenv.hostPlatform.rust.rustcTargetSpec} \
      --package buzzodz-plugins --bin buzzodz
  '';
  disallowedReferences = [ finalAttrs.src ];

  nativeCheckInputs = [
    # Tests build HTTP clients, which need the system CA certificates.
    cacert
    gitMinimal
    # A host process test detaches a child with perl's setpgrp.
    perl
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    dbus
    # The agent command tests find a host's child with pgrep.
    procps
  ];
  # macOS: the relay admin tests verify a test certificate through the Security
  # framework, which needs trustd.
  sandboxProfile = ''
    (allow mach-lookup (global-name "com.apple.trustd") (global-name "com.apple.trustd.agent") (global-name "com.apple.SecurityServer"))
  '';
  # The tests start servers on 127.0.0.1.
  __darwinAllowLocalNetworking = true;

  # The whole workspace, as upstream's CI tests it.
  cargoTestFlags = [
    "--workspace"
    "--no-fail-fast"
  ];
  checkFlags = map (test: "--skip=${test}") (
    [
      # Nixpkgs runs the tests in the release profile; this one expects the
      # debug-build refusal (https://github.com/block/buzz-app/pull/1778).
      "sign_out::tests::production_acl_lets_the_dialog_ask_why_wipe_is_unavailable"
      # Asserts it runs as a debug build
      # (https://github.com/block/buzz-app/pull/4210).
      "cli_link::tests::only_the_installed_release_owns_the_link"
      # A `#!/usr/bin/env` script; the sandbox has no /usr/bin/env.
      "host_command::tests::env_shebang_uses_the_path_that_resolved_the_command"
      # Expects an error because the temporary directory has no parent named
      # `build`; the sandbox's temporary directory is /build (or /nix/build/…)
      # (https://github.com/block/buzz-app/pull/1961).
      "build_resources::tests::leaves_unrelated_output_and_rejects_an_unknown_cargo_layout"
      # The login shell gets its PATH from /etc/profile and the probe runs
      # /usr/bin/env; the sandbox has neither.
      "terminal::tests::real_spawn_fences_secrets_and_preserves_login_context"
      # The tests' shell gets PATH=/usr/bin:/bin, so it can't find
      # sleep, stty or env in the sandbox
      # (https://github.com/block/buzz-app/pull/1779).
      "terminal::tests::coalesced_reads_return_sparse_output_promptly"
      "terminal::tests::each_coalesced_read_is_bounded_while_a_child_writes_continuously"
      "terminal::tests::foreground_job_receives_ctrl_c_and_close_stops_job_control_group"
      "terminal::tests::interactive_input_resize_and_owner_isolation"
      "terminal::tests::large_final_output_is_fully_drained_before_exited"
      "terminal::tests::shutdown_kills_a_signal_ignoring_group_and_reaps_the_leader"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # Runs /bin/bash, which the sandbox lacks; only protected workers use
      # it, and those run on macOS only (https://github.com/block/buzz-app/issues/2416).
      "bundled_shell_ignores_path_startup_and_imported_functions_without_mcp"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # The login shell probe runs /usr/bin/env, printf and printenv, which the
      # sandbox doesn't have.
      "host_command::tests::login_shell_exports_path_and_the_variables_it_lists"
      "host_command::tests::login_shell_path_survives_an_env_without_nul_output"
      "host_command::tests::login_shell_wildcard_leaves_out_what_describes_the_probe"
      "host_command::tests::app_exit_kills_a_running_login_shell_probe"
      # Expects the Xcode git shim at /usr/bin/git
      # (https://github.com/block/buzz-app/pull/1780).
      "relay::project_git::tests::macos_git_selection_skips_unavailable_shim_without_launching_it"
      # Sets a macOS ACL with `chmod +a`, which the build's coreutils chmod lacks;
      # the sandbox has no /bin/chmod.
      "sign_out::tests::an_uninspectable_kept_registry_stops_the_wipe_and_the_retry_keeps_it"
      # Same PATH as the terminal tests above, which shows up as EPERM here
      # (https://github.com/block/buzz-app/pull/1779).
      "terminal::tests::a_held_or_closing_session_does_not_block_another_session"
      "terminal::tests::bounded_input_and_session_admission"
      # Run macOS tools the build sandbox blocks: sandbox-exec (which can't nest
      # in it anyway), /usr/sbin/lsof, /usr/sbin/sysctl, /bin/sleep and /usr/bin/true.
      "host_process::protection::tests::kernel_denies_control_writes_and_private_reads_while_workspace_remains_writable"
      "host_process::protection::tests::kernel_denies_creating_a_missing_read_only_leaf"
      "host_process::protection::tests::kernel_denies_creating_the_missing_folders_of_a_read_only_path"
      "catalog::tests::macos_hosting_survey_reports_physical_memory"
      "host_process::tests::protected_launches_keep_the_startup_agents_root_when_release_storage_appears"
      "host_process::tests::snapshot_mcp_and_containment_keep_the_verified_target_and_argument_order"
      "relaunch::macos::tests::opens_the_bundle_only_after_the_process_has_exited"
      "webkit_reaper::tests::a_process_is_identified_by_pid_start_time_and_binary"
      "a_sandbox_denied_connection_keeps_the_advertisement"
      "fresh_agents_find_advertised_sessions_and_drop_stale_ones"
      "contained_file_reader_allows_workspace_but_denies_private_paths_and_aliases"
      # Find a host's child with pgrep, which nixpkgs has only for Linux; the
      # sandbox hides macOS's /usr/bin/pgrep.
      "a_command_retains_the_lease_after_its_helper_is_terminated"
      "a_second_build_waits_then_takes_over_the_attention_source"
      "a_waiting_command_exits_when_its_host_dies"
      "command_tree_exits_when_its_host_dies"
    ]
  );

  # Upstream's update plugin is only compiled in when the build sets an update
  # endpoint and key (cfg buzz_updater_enabled); make sure a Nix build never
  # ships it. Then check what the desktop integration and media features rely on.
  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    app=${
      if stdenv.hostPlatform.isDarwin then
        "$out/Applications/Buzz.app/Contents/MacOS/.Buzz-wrapped"
      else
        "$out/bin/.Buzz-wrapped"
    }
    # The plugin's code and upstream's preview feed URL (which release builds
    # pass in the Tauri config) are both absent from a build without it.
    for marker in tauri-plugin-updater releases/download/preview-feed/latest.json; do
      if grep -q "$marker" "$app"; then
        echo "the updater is compiled into the application ($marker)" >&2
        exit 1
      fi
    done
    # The bundled Goose agent answers an ACP handshake (and exits when stdin closes).
    echo '{"jsonrpc":"2.0","id":1,"method":"initialize","params":{"protocolVersion":1,"clientCapabilities":{}}}' \
      | HOME="$(mktemp -d)" "${resourceDir}/bin/goose-acp" | grep -q '"agentCapabilities"'
    test -x "${resourceDir}/bin/buzz-agent-command"
    "${resourceDir}/bin/buzz" --help > /dev/null
    $out/bin/buzzodz --home "$(mktemp -d)" plugin list > /dev/null
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # buzz:// links open the app, with the link as its argument.
    grep -q '^MimeType=x-scheme-handler/buzz' "$out/share/applications/Buzz Foundation.desktop"
    grep -q '^Exec=Buzz %u$' "$out/share/applications/Buzz Foundation.desktop"
    # Voice notes and media playback.
    export GST_PLUGIN_SYSTEM_PATH_1_0=${
      lib.makeSearchPathOutput "lib" "lib/gstreamer-1.0" gstreamerPlugins
    }
    export GST_REGISTRY_1_0=$TMPDIR/gst-registry.bin
    for element in filesrc playbin3 mpg123audiodec avdec_h264; do
      ${lib.getExe' gst_all_1.gstreamer "gst-inspect-1.0"} $element > /dev/null
    done
  ''
  + ''
    runHook postInstallCheck
  '';

  postInstall = ''
    install -Dm755 target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/buzzodz -t $out/bin
  ''
  # The handler file the patch above removes passed the link with %u; the
  # packaged entry has to as well. Tauri's bundler leaves it out; fixed in
  # https://github.com/tauri-apps/tauri/pull/15929, not yet in a cargo-tauri release.
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    substituteInPlace "$out/share/applications/Buzz Foundation.desktop" \
      --replace-fail 'Exec=Buzz' 'Exec=Buzz %u'
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -s ../Applications/Buzz.app/Contents/MacOS/Buzz $out/bin/Buzz
  '';

  # One shell wrapper with the GApps arguments; see postFixup.
  dontWrapGApps = true;

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      ${lib.escapeShellArgs appWrapperArgs}
    )
  '';

  postFixup =
    # A shell wrapper because the registry path depends on $HOME at runtime
    # (`--run`). It stays in bin/: Tauri finds the resources relative to the
    # executable.
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgramShell $out/bin/Buzz \
        "''${gappsWrapperArgs[@]}" \
        --run ${lib.escapeShellArg registrySetup}
    ''
    # A binary wrapper stays the bundle's executable, so it applies from Finder
    # too; one ad-hoc signature, no hardened runtime (Tauri ran with --no-sign).
    # The Nix-built curl, git and node on PATH get cacert's CA bundle.
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapProgram $out/Applications/Buzz.app/Contents/MacOS/Buzz \
        ${lib.escapeShellArgs (
          appWrapperArgs
          ++ [
            "--set-default"
            "SSL_CERT_FILE"
            "${cacert}/etc/ssl/certs/ca-bundle.crt"
          ]
        )}
      rcodesign sign $out/Applications/Buzz.app
    '';

  passthru = {
    # Stable releases only: the v*-preview.* and v*-beta.* tags are test builds.
    updateScript = nix-update-script {
      extraArgs = [ "--version-regex=^v(\\d+\\.\\d+\\.\\d+)$" ];
    };
  };

  meta = {
    description = "Team chat and AI agent workspace built on Nostr";
    longDescription = ''
      Buzz is a workspace for team chat, huddles and AI agents, built on Nostr.
      This is the Buzz 1.0 app (block/buzz-app), built from its stable release tags.
      It bundles goose; the Claude Code and Codex plugins download their own
      agents at runtime, and Claude Code's download is a prebuilt binary that
      needs nix-ld on NixOS. Shared compute runs models with skippy-native-runtime:
      Metal on macOS; on Linux CPU, or the GPU backend of the nixpkgs settings
      `cudaSupport` or `rocmSupport`, or Vulkan with skippy-native-runtime
      overridden to `vulkanSupport = true`.
    '';
    homepage = "https://github.com/block/buzz-app";
    changelog = "https://github.com/block/buzz-app/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    mainProgram = "Buzz";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
    inherit (runtime.meta) badPlatforms;
  };
})

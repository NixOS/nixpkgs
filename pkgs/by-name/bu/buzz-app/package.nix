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
  gtk3,
  libsoup_3,
  webkitgtk_4_1,
  glib-networking,
  gst_all_1,
  goose-cli,
  cacert,
  coreutils,
  curl,
  gitMinimal,
  ffmpeg-headless,
  nix-update-script,
  gitUpdater,
  _experimental-update-script-combinators,
}:

let
  rustTarget = stdenv.hostPlatform.rust.rustcTarget;

  # The goose ACP server the app bundles as its Goose agent. Upstream builds a
  # standalone goose-acp from a pinned goose main commit (runtime/goose-acp.json)
  # during `tauri build`; `goose acp` from nixpkgs' goose-cli runs the same
  # server (goose::acp::server::run), so goose stays maintained in one place.
  # It follows nixpkgs' goose version, which can be older than upstream's pin.
  goose-acp = runCommand "goose-acp-${goose-cli.version}" {
    nativeBuildInputs = [ makeBinaryWrapper ];
  } "makeWrapper ${lib.getExe goose-cli} $out/bin/goose-acp --add-flags acp";

  # Fallbacks only, the user's own tools come first. Plugins run git (projects),
  # ffmpeg (media uploads) and node (the Pi agent) from PATH, and the Claude Code
  # and Codex plugin scripts download their agents with curl and check them with
  # coreutils' sha256sum.
  runtimePath = lib.makeBinPath [
    gitMinimal
    ffmpeg-headless
    nodejs_24
    curl
    coreutils
  ];

  # No SSL_CERT_FILE on Linux: the app and its agents use the system CA store,
  # which includes certificates added with security.pki.
  appWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    runtimePath
  ];

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
  version = "0.7.0";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz-app";
    tag = "desktop-v${finalAttrs.version}";
    hash = "sha256-bZcITM+06BvyapOc2/fbLBWlFil/E+kUYksAC1OVo64=";
  };

  buildAndTestSubdir = "src-tauri";
  cargoHash = "sha256-HjVduf/cgNKpzRCP7UEypx3q7kF0c+KKETvDh1FPKiE=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    # Upstream's package.json pins pnpm 11 (`packageManager`).
    pnpm = pnpm_11;
    fetcherVersion = 5;
    hash = "sha256-Npv5d0+ntSxYUdrsgVBACA/V6IfsF9kPrRnjQmVXaW0=";
  };

  patches = [
    # On Linux the app makes itself the default buzz:// handler on every start
    # (on purpose upstream, so that it wins over Buzz 0.X): tauri-plugin-deep-link
    # writes ~/.local/share/applications/<binary>-handler.desktop with the running
    # binary and sets it with `xdg-mime default`. Under Nix that binary is the
    # unwrapped store path, so links skip the wrapper, and after an update they
    # open the old version until the new one has started once. The packaged
    # .desktop file declares the scheme instead. Not upstreamed: a .deb or
    # AppImage launches a stable path, so this only matters for Nix.
    ./no-linux-scheme-self-registration.patch
  ];

  postPatch = ''
    install -Dm755 ${goose-acp}/bin/goose-acp src-tauri/resources/bin/goose-acp

    # Test fixtures run tools from /bin and /usr/bin, which the build sandbox
    # lacks; https://github.com/block/buzz-app/pull/1779 runs them from PATH.
    substituteInPlace src-tauri/src/test_executable.rs \
      --replace-fail '"/bin/cp"' '"${lib.getExe' coreutils "cp"}"'
    substituteInPlace src-tauri/src/relay/media_preparation.rs \
      --replace-fail '"/bin/kill"' '"${lib.getExe' coreutils "kill"}"'
    substituteInPlace src-tauri/src/host_command.rs \
      --replace-fail /usr/bin/head ${lib.getExe' coreutils "head"} \
      --replace-fail /usr/bin/tr ${lib.getExe' coreutils "tr"}
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    wrapGAppsHook3
    makeShellWrapper
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    makeBinaryWrapper
    rcodesign
  ];

  buildInputs = lib.optionals stdenv.hostPlatform.isLinux (
    [
      gtk3
      libsoup_3
      webkitgtk_4_1
      glib-networking
    ]
    ++ gstreamerPlugins
  );

  env = {
    # The bundled Builderlab plugin's login URL, compiled in; upstream's release
    # workflow sets the same default (.github/workflows/release.yml).
    BUZZ_BUILDERLAB_URL = "https://app.builderlab.xyz";
    # Build aws-lc (rustls' crypto) with nixpkgs' cmake instead of the crate's
    # cc-based builder.
    AWS_LC_SYS_CMAKE_BUILDER = 1;
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
        # Upstream's command also fetches and builds goose-acp, which postPatch
        # provides instead; https://github.com/block/buzz-app/pull/1781 lets
        # packagers pass a prebuilt one.
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
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [ dbus ];
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
      # A `#!/usr/bin/env` script; the sandbox has no /usr/bin/env.
      "host_command::tests::env_shebang_uses_the_path_that_resolved_the_command"
      # Expects an error because the temporary directory has no parent named
      # `build`; the sandbox's temporary directory is /build (or /nix/build/…).
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
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # The login shell probe runs /usr/bin/env, printf and printenv, which the
      # sandbox doesn't have.
      "host_command::tests::login_shell_path_is_read_past_profile_output"
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
  # packaged entry has to as well. Tauri's bundler leaves it out:
  # https://github.com/tauri-apps/tauri/issues/15928
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
    # A binary wrapper inside the bundle stays the app's executable, so it also
    # applies when the app is started from Finder. Then give the bundle one
    # ad-hoc signature (Tauri ran with --no-sign). No hardened runtime, so the
    # binaries load their Nix-store libraries without extra entitlements.
    # On macOS the Nix-built curl, git and node on PATH have no CA bundle of their
    # own, so they get cacert's.
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
    # The desktop-v* tags. nix-update reads GitHub releases, which only the
    # v*-preview.* tags of upstream's main builds have, so gitUpdater picks the
    # tag and nix-update updates the hashes.
    updateScript = _experimental-update-script-combinators.sequence [
      (gitUpdater {
        rev-prefix = "desktop-v";
        ignoredVersions = "-";
      }).command
      (nix-update-script { extraArgs = [ "--version=skip" ]; })
    ];
  };

  meta = {
    description = "Team chat and AI agent workspace built on Nostr (1.0 beta)";
    longDescription = ''
      Buzz is a workspace for team chat, huddles and AI agents, built on Nostr.
      This is the Buzz 1.0 app (block/buzz-app), which upstream calls a beta, built
      from its desktop release tags.
      It bundles goose; the Claude Code and Codex plugins download their own
      agents at runtime, and Claude Code's download is a prebuilt binary that
      needs nix-ld on NixOS.
    '';
    homepage = "https://github.com/block/buzz-app";
    license = lib.licenses.asl20;
    mainProgram = "Buzz";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})

{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
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
  dbus,
  openssl,
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
}:

let
  rustTarget = stdenv.hostPlatform.rust.rustcTarget;

  # The goose ACP server the app bundles as its Goose agent. Upstream builds it
  # from a pinned goose main commit (runtime/goose-acp.json) with a script that
  # fetches and builds goose during `tauri build`; this builds the same binary,
  # with the same features, from the goose release in nixpkgs.
  goose-acp = rustPlatform.buildRustPackage {
    pname = "goose-acp";
    inherit (goose-cli) version src cargoDeps;

    __structuredAttrs = true;

    # goose's own size-optimised profile (fat LTO, opt-level "z"), which
    # upstream's script also uses: less than half the release build's size.
    buildType = "lean";

    cargoBuildFlags = [
      "--package"
      "goose"
      "--bin"
      "goose-acp"
    ];
    buildNoDefaultFeatures = true;
    buildFeatures = [
      "rustls-tls"
      "system-keyring"
      "online-model-meta"
    ];

    # Less than goose-cli needs: these features pull in neither V8 nor protobuf.
    nativeBuildInputs = [
      cmake
      pkg-config
    ];
    buildInputs = lib.optionals stdenv.hostPlatform.isLinux [ dbus ];

    # cmake is only used by dependency build scripts
    dontUseCmakeConfigure = true;

    # Same reason as goose-cli: the goose test suite isn't gated upstream and
    # needs network, dbus and loopback access.
    doCheck = false;

    meta = goose-cli.meta // {
      mainProgram = "goose-acp";
    };
  };

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

  appWrapperArgs = [
    "--suffix"
    "PATH"
    ":"
    runtimePath
    "--set-default"
    "SSL_CERT_FILE"
    "${cacert}/etc/ssl/certs/ca-bundle.crt"
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
  # No release yet: upstream only publishes previews from main
  # (v0.0.0-preview.<run>.<attempt>), whose tags are deleted after a week.
  version = "0-unstable-2026-10-23";

  __structuredAttrs = true;
  strictDeps = true;

  src = fetchFromGitHub {
    owner = "block";
    repo = "buzz-app";
    rev = "f4e95770886a804cc7fae2769cbcc425ffafa73c";
    hash = "sha256-e+E4GBd8z8p9lKNMbBKTk8wSdLWaOiVgDiyMJSAg4tQ=";
  };

  buildAndTestSubdir = "src-tauri";
  cargoHash = "sha256-n520zYtBxJQdEP8eBmH3ZjMi/YHnjHyiZ5wx5NlGkXQ=";

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    # Upstream's package.json pins pnpm 11 (`packageManager`).
    pnpm = pnpm_11;
    fetcherVersion = 4;
    hash = "sha256-VnxI+dQkYdwogfn7/AZAtUo/xA0xhldcn4GHTmLl6RI=";
  };

  patches = [
    # On Linux the app registers itself as the buzz:// handler on every start, by
    # writing a .desktop file with its own path to ~/.local/share/applications.
    # That path is the unwrapped store binary: it goes stale with the next update,
    # skips the wrapper and takes buzz:// from other installs. The packaged
    # .desktop file declares the scheme instead. Nix-specific, so not upstreamed.
    ./no-linux-scheme-self-registration.patch
  ];

  postPatch = ''
    install -Dm755 ${lib.getExe goose-acp} src-tauri/resources/bin/goose-acp

    # Test fixtures run tools from /bin and /usr/bin, which the build sandbox lacks.
    substituteInPlace src-tauri/src/test_executable.rs \
      --replace-fail '"/bin/cp"' '"${lib.getExe' coreutils "cp"}"'
    substituteInPlace src-tauri/src/relay/media_preparation.rs \
      --replace-fail '"/bin/kill"' '"${lib.getExe' coreutils "kill"}"'
    substituteInPlace src-tauri/src/host_command.rs \
      --replace-fail /usr/bin/head ${lib.getExe' coreutils "head"} \
      --replace-fail /usr/bin/tr ${lib.getExe' coreutils "tr"}
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
    openssl
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
    # The bundled Builderlab plugin's login URL, compiled in; upstream's release
    # workflow sets the same default (.github/workflows/release.yml).
    BUZZ_BUILDERLAB_URL = "https://app.builderlab.xyz";
    AWS_LC_SYS_CMAKE_BUILDER = 1;
    # The keyring crate enables openssl's `vendored` feature; link nixpkgs' openssl.
    OPENSSL_NO_VENDOR = 1;
  };

  # cmake is only used by dependency build scripts
  dontUseCmakeConfigure = true;

  cargoBuildFlags = [
    "--package"
    "buzz-foundation"
  ];

  doNotPostBuildInstallCargoBinaries = true;
  tauriBuildFlags = [
    "--no-sign"
    "--config"
    (builtins.toJSON (
      {
        # Upstream's command also builds goose-acp (git fetch + cargo build),
        # which postPatch provides instead.
        build.beforeBuildCommand = "pnpm build";
      }
      // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
        # Tauri otherwise declares an older macOS than Nixpkgs builds for.
        bundle.macOS.minimumSystemVersion = stdenv.hostPlatform.darwinMinVersion;
      }
    ))
  ];

  # Panic messages would otherwise carry the temporary build directory.
  preBuild = ''
    export RUSTFLAGS="--remap-path-prefix=$NIX_BUILD_TOP=/build ''${RUSTFLAGS:-}"
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
  ];
  # The tests start servers on 127.0.0.1.
  __darwinAllowLocalNetworking = true;

  checkFlags = map (test: "--skip=${test}") (
    [
      # Nixpkgs runs the tests in the release profile; this one expects the
      # debug-build refusal.
      "sign_out::tests::production_acl_lets_the_dialog_ask_why_wipe_is_unavailable"
      # A `#!/usr/bin/env` script; the sandbox has no /usr/bin/env.
      "host_command::tests::env_shebang_uses_the_path_that_resolved_the_command"
      # The built-in terminal sets PATH to /usr/local/bin:/usr/bin:/bin:… for its
      # shell, so these tests can't find sleep, stty or env in the sandbox.
      "terminal::tests::coalesced_reads_return_sparse_output_promptly"
      "terminal::tests::each_coalesced_read_is_bounded_while_a_child_writes_continuously"
      "terminal::tests::foreground_job_receives_ctrl_c_and_close_stops_job_control_group"
      "terminal::tests::interactive_input_resize_and_owner_isolation"
      "terminal::tests::large_final_output_is_fully_drained_before_exited"
      "terminal::tests::real_spawn_fences_secrets_and_preserves_login_context"
      "terminal::tests::shutdown_kills_a_signal_ignoring_group_and_reaps_the_leader"
    ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      # These start `dbus-daemon --session`, which reads /etc/dbus-1/session.conf,
      # missing in the sandbox.
      "notifications::linux::tests"
    ]
    ++ lib.optionals stdenv.hostPlatform.isDarwin [
      # Most of these serve a test certificate that the client verifies through
      # the Security framework, which fails in the sandbox (OSStatus -26276).
      "relay_admin::tests"
      # Expects the Xcode git shim at /usr/bin/git.
      "relay::project_git::tests::macos_git_selection_skips_unavailable_shim_without_launching_it"
      # Sets a macOS ACL with `chmod +a`, which the build's coreutils chmod lacks.
      "sign_out::tests::an_uninspectable_kept_registry_stops_the_wipe_and_the_retry_keeps_it"
      # The sandbox refuses the terminal's process-group cleanup (EPERM).
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
        "$out/Applications/Buzz.app/Contents/MacOS/.buzz-foundation-wrapped"
      else
        "$out/bin/.buzz-foundation-wrapped"
    }
    # The plugin's code and upstream's preview feed URL (which release builds
    # pass in the Tauri config) are both absent from a build without it.
    for marker in tauri-plugin-updater releases/download/preview-feed/latest.json; do
      if grep -q "$marker" "$app"; then
        echo "the updater is compiled into the application ($marker)" >&2
        exit 1
      fi
    done
    test -x "${resourceDir}/bin/goose-acp"
    $out/bin/buzzodz --home "$(mktemp -d)" plugin list > /dev/null
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    # buzz:// links open the app.
    grep -q 'x-scheme-handler/buzz' "$out/share/applications/Buzz Foundation.desktop"
    # Voice notes and media playback.
    export GST_PLUGIN_SYSTEM_PATH_1_0=${lib.makeSearchPath "lib/gstreamer-1.0" gstreamerPlugins}
    export GST_REGISTRY_1_0=$TMPDIR/gst-registry.bin
    for element in playbin3 mpg123audiodec avdec_h264; do
      ${lib.getExe' gst_all_1.gstreamer "gst-inspect-1.0"} $element > /dev/null
    done
  ''
  + ''
    runHook postInstallCheck
  '';

  postInstall = ''
    install -Dm755 target/${stdenv.hostPlatform.rust.cargoShortTarget}/release/buzzodz -t $out/bin
  ''
  + lib.optionalString stdenv.hostPlatform.isDarwin ''
    ln -s ../Applications/Buzz.app/Contents/MacOS/buzz-foundation $out/bin/buzz-foundation
  '';

  # One shell wrapper with the GApps arguments; see postFixup.
  dontWrapGApps = true;

  preFixup = lib.optionalString stdenv.hostPlatform.isLinux ''
    gappsWrapperArgs+=(
      ${lib.escapeShellArgs appWrapperArgs}
      --prefix GST_PLUGIN_SYSTEM_PATH_1_0 : "${lib.makeSearchPath "lib/gstreamer-1.0" gstreamerPlugins}"
    )
  '';

  postFixup =
    # A shell wrapper because the registry path depends on $HOME at runtime
    # (`--run`). It stays in bin/: Tauri finds the resources relative to the
    # executable.
    lib.optionalString stdenv.hostPlatform.isLinux ''
      wrapProgramShell $out/bin/buzz-foundation \
        "''${gappsWrapperArgs[@]}" \
        --run ${lib.escapeShellArg registrySetup}
    ''
    # A binary wrapper inside the bundle stays the app's executable, so it also
    # applies when the app is started from Finder. Then give the bundle one
    # ad-hoc signature (Tauri ran with --no-sign). No hardened runtime, so the
    # binaries load their Nix-store libraries without extra entitlements.
    + lib.optionalString stdenv.hostPlatform.isDarwin ''
      wrapProgram $out/Applications/Buzz.app/Contents/MacOS/buzz-foundation \
        ${lib.escapeShellArgs appWrapperArgs}
      rcodesign sign $out/Applications/Buzz.app
    '';

  passthru = {
    inherit goose-acp;
    # Keep 0-unstable-<date> until the first stable tag, not a preview tag.
    updateScript = nix-update-script {
      extraArgs = [
        "--version=branch"
        "--version-regex=^(0-unstable-.*)$"
      ];
    };
  };

  meta = {
    description = "Team chat and AI agent workspace built on Nostr (1.0 preview)";
    longDescription = ''
      Buzz is a workspace for team chat, huddles and AI agents, built on Nostr.
      This is the Buzz 1.0 app (block/buzz-app), built from the main branch.
      It bundles goose; the Claude Code and Codex plugins download their own
      agents at runtime, and Claude Code's download is a prebuilt binary that
      may need nix-ld on NixOS.
    '';
    homepage = "https://github.com/block/buzz-app";
    license = lib.licenses.asl20;
    mainProgram = "buzz-foundation";
    maintainers = with lib.maintainers; [ kleinbem ];
    platforms = [
      "x86_64-linux"
      "aarch64-linux"
      "aarch64-darwin"
    ];
  };
})

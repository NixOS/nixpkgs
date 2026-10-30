{
  lib,
  stdenv,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  alsa-lib,
  bash,
  bubblewrap,
  cacert,
  clang,
  cmake,
  coreutils,
  curl,
  gitMinimal,
  gst_all_1,
  libcap,
  libclang,
  libopus,
  librusty_v8 ? callPackage ./librusty_v8.nix {
    inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8;
  },
  librusty_v8_src_binding ? callPackage ./librusty_v8_src_binding.nix {
    inherit (callPackage ./fetchers.nix { }) fetchLibrustyV8SrcBinding;
  },
  linkFarm,
  lld,
  nix-update-script,
  pkg-config,
  openssl,
  ps,
  replaceVars,
  ripgrep,
  versionCheckHook,
  writeText,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  _experimental-update-script-combinators,
}:
let
  supportsVoice =
    stdenv.hostPlatform.isDarwin || (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isGnu);
  voiceRuntimeRoots = [
    (lib.getLib gst_all_1.gstreamer)
    (lib.getLib gst_all_1.gst-plugins-base)
    (lib.getLib gst_all_1.gst-plugins-good)
  ];
  # Voice loads a fixed package-relative runtime, ignoring GStreamer discovery.
  voiceRuntime =
    let
      pluginDirectory = if stdenv.hostPlatform.isDarwin then "plugins" else "lib/gstreamer-1.0";
      pluginSuffix = stdenv.hostPlatform.extensions.sharedLibrary;
      plugin = package: name: {
        path = "${lib.getLib package}/lib/gstreamer-1.0/libgst${name}${pluginSuffix}";
        name = "${pluginDirectory}/libgst${name}${pluginSuffix}";
      };
      coreSuffix = if stdenv.hostPlatform.isDarwin then "0.dylib" else "so.0";
    in
    linkFarm "codex-voice-runtime" [
      {
        path = "${lib.getLib gst_all_1.gstreamer}/lib/libgstreamer-1.0.${coreSuffix}";
        name = "lib/libgstreamer-1.0.${coreSuffix}";
      }
      (plugin gst_all_1.gstreamer "coreelements")
      (plugin gst_all_1.gst-plugins-base "app")
      (plugin gst_all_1.gst-plugins-base "audioconvert")
      (plugin gst_all_1.gst-plugins-base "audioresample")
      (plugin gst_all_1.gst-plugins-base "opus")
      (plugin gst_all_1.gst-plugins-good "rtp")
      (plugin gst_all_1.gst-plugins-good "rtpmanager")
    ];
in
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex";
  version = "0.165.0";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = finalAttrs.buildCommit;
    hash = "sha256-b9PpwNQeZsJIN4wbGA3FLfWAKd2EDMN5E/zj/Y62/vk=";
  };

  # Matching client/helper stamps; build_id() requires a full commit SHA.
  buildCommit = "360319d8dee62d87e2d59fc0c21805d79519cfed";

  sourceRoot = "${finalAttrs.src.name}/codex-rs";

  cargoHash = "sha256-KKC/uHE2RWq0U7FmXA+TKTlFf/d8vYe6/G8gl78bW+g=";
  # Disable bundled Opus so OPUS_LIB_DIR selects nixpkgs' libopus.
  cargoDeps =
    (rustPlatform.fetchCargoVendor {
      inherit (finalAttrs)
        pname
        version
        src
        sourceRoot
        ;
      hash = finalAttrs.cargoHash;
    }).overrideAttrs
      (previousAttrs: {
        buildCommand = previousAttrs.buildCommand + ''
          chmod +w "$out/source-registry-0/opusic-sys-0.7.5/Cargo.toml"
          substituteInPlace "$out/source-registry-0/opusic-sys-0.7.5/Cargo.toml" \
            --replace-fail 'default = ["bundled"]' 'default = []'
        '';
      });

  __structuredAttrs = true;

  # Match upstream's release build for the codex binary, plus its
  # codex-code-mode-host runtime companion for out-of-process V8 execution.
  cargoBuildFlags = [
    "--package"
    "codex-cli"
    "--package"
    "codex-code-mode-host"
  ]
  ++ lib.optionals supportsVoice [
    "--package"
    "codex-voice-host"
  ];
  cargoTestFlags = [
    "--package"
    "codex-cli"
    "--package"
    "codex-code-mode-host"
  ]
  ++ lib.optionals supportsVoice [
    "--package"
    "codex-voice-host"
  ];

  # Integration fixtures require debug assertions for temporary homes and HTTP.
  checkType = "ci-test";

  checkFlags = [
    # WebRTC peer tests require multicast, unavailable in the build sandbox.
    "--skip=transport::tests::negotiates_real_ordered_channel_over_udp_and_tcp"
    "--skip=transport::tests::negotiates_after_early_packet_loss_and_slow_tcp_connect"
    "--skip=transport::tests::rejects_excess_or_invalid_candidates_before_mutating_peer"
    "--skip=transport::tests::invalid_answer_is_redacted_and_peer_can_close"
    "--skip=devices::capture_worker::tests::capture_reaches_remote_rtp_and_mute_discards_queued_and_partial_audio"

    # Local package installation fixtures assume a development version without auto-updates.
    "--skip=packaged_daemon_"
  ];

  patches = [
    # Allow declared store links through daemon package validation.
    (replaceVars ./nix-package-layout.patch {
      ps = lib.getExe ps;
      packageLinkRoots = lib.concatStringsSep ":" (
        [ (toString (lib.getBin ripgrep)) ]
        ++ lib.optionals stdenv.hostPlatform.isLinux [ (toString (lib.getBin bubblewrap)) ]
        ++ lib.optionals supportsVoice (map toString voiceRuntimeRoots)
      );
    })
  ]
  ++ lib.optionals supportsVoice [
    # Likewise for the voice loader, independently of daemon mode.
    (replaceVars ./nix-voice-runtime.patch {
      voiceRuntimeRoots = lib.concatStringsSep ":" (map toString voiceRuntimeRoots);
    })
  ]
  ++ [
    # https://github.com/openai/codex/issues/48195
    ./no-daemon_auto_start.patch
  ];

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'lto = "thin"' "" \
      --replace-fail 'codegen-units = 4' ""

    sed -i '1i#![recursion_limit = "256"]' chatgpt/src/lib.rs

    substituteInPlace utils/cargo-bin/src/executable.rs \
      --replace-fail '/bin/cp' '${lib.getExe' coreutils "cp"}'
    substituteInPlace cli/tests/exec_server.rs \
      --replace-fail '/bin/sleep' '${lib.getExe' coreutils "sleep"}'
    substituteInPlace cli/tests/exec_server/pid_namespace_tests.rs \
      --replace-fail '/bin/true' '${lib.getExe' coreutils "true"}' \
      --replace-fail '/bin/bash' '${lib.getExe bash}'
    substituteInPlace cli/tests/app_server_daemon{,/support}.rs \
      --replace-fail '/bin/ps' '${lib.getExe ps}'
  '';

  nativeBuildInputs = [
    clang
    cmake
    gitMinimal
    installShellFiles
    pkg-config
  ];

  buildInputs = [
    libclang
    openssl
  ]
  ++ lib.optionals supportsVoice [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    libopus
  ]
  ++ lib.optionals (supportsVoice && stdenv.hostPlatform.isLinux) [
    alsa-lib
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
  ];

  # NOTE: set LIBCLANG_PATH so bindgen can locate libclang, and adjust
  # warning-as-error flags to avoid known false positives (GCC's
  # stringop-overflow in BoringSSL's a_bitstr.cc) while keeping Clang's
  # character-conversion warning-as-error disabled.
  env = {
    CODEX_BUILD_COMMIT = finalAttrs.buildCommit;
    LIBCLANG_PATH = "${lib.getLib libclang}/lib";
    NIX_CFLAGS_COMPILE = toString (
      lib.optionals stdenv.cc.isGNU [
        "-Wno-error=stringop-overflow"
      ]
      ++ lib.optionals stdenv.cc.isClang [
        "-Wno-error=character-conversion"
      ]
    );
    RUSTY_V8_ARCHIVE = librusty_v8;
    RUSTY_V8_SRC_BINDING_PATH = librusty_v8_src_binding;
    STABLE_GIT_COMMIT = finalAttrs.buildCommit;
  }
  // lib.optionalAttrs supportsVoice {
    OPUS_LIB_DIR = "${lib.getLib libopus}/lib";
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Link with lld on Darwin. nixpkgs' classic open-source ld64 fails to insert
    # ARM64 branch thunks for this binary, producing `b(l) ARM64 branch out of range`.
    NIX_CFLAGS_LINK = "-fuse-ld=${lib.getExe' lld "ld64.lld"}";
  };

  # Darwin integration tests require additional sandbox and fixture adaptations.
  doCheck = stdenv.hostPlatform.isLinux;

  nativeCheckInputs = [
    # HTTP clients validate SSL_CERT_FILE even when talking to local test servers.
    cacert
    ps
  ]
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    bubblewrap
    curl
  ];

  # codex-voice-host is moved out of bin/ before fixup; strip it too, or its
  # debug info keeps gcc and glibc.dev in the runtime closure.
  stripDebugList = [
    "bin"
    "codex-resources"
  ];

  # Metadata enables voice package discovery even without a daemon.
  # Patch ps and package rg/bwrap directly: a wrapper fails the daemon's
  # staged-vs-running executable content check.
  postInstall = ''
    install -Dm444 \
      ${
        writeText "codex-package.json" (
          builtins.toJSON {
            layoutVersion = 1;
            version = finalAttrs.version;
            target = stdenv.hostPlatform.rust.rustcTarget;
            variant = "codex";
            entrypoint = "bin/codex";
            resourcesDir = "codex-resources";
          }
        )
      } \
      $out/codex-package.json

    # Daemon validation requires packaged rg/bwrap despite their PATH fallback.
    install -d $out/codex-path
    ln -s ${lib.getExe ripgrep} $out/codex-path/rg
  ''
  + lib.optionalString stdenv.hostPlatform.isLinux ''
    install -d $out/codex-resources
    ln -s ${lib.getExe bubblewrap} $out/codex-resources/bwrap
  ''
  + lib.optionalString supportsVoice ''
    install -d $out/codex-resources/voice/bin
    mv $out/bin/codex-voice-host $out/codex-resources/voice/bin/
    cp -a ${voiceRuntime}/. $out/codex-resources/voice/
  ''
  + lib.optionalString installShellCompletions ''
    installShellCompletion --cmd codex \
      --bash <($out/bin/codex completion bash) \
      --fish <($out/bin/codex completion fish) \
      --zsh <($out/bin/codex completion zsh)
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    ./update-build-commit.sh
    (nix-update-script {
      extraArgs = [
        "--use-github-releases"
        "--version-regex"
        "^rust-v(\\d+\\.\\d+\\.\\d+)$"
      ];
    })
    ./update-librusty.sh
  ];

  passthru.tests = {
    app-server-daemon = callPackage ./test-app-server-daemon.nix { codex = finalAttrs.finalPackage; };
  }
  // lib.optionalAttrs supportsVoice {
    voice-runtime = callPackage ./test-voice-runtime.nix { codex = finalAttrs.finalPackage; };
  };

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    changelog = "https://raw.githubusercontent.com/openai/codex/refs/tags/rust-v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "codex";
    maintainers = with lib.maintainers; [
      delafthi
      jeafleohj
      malo
    ];
    platforms = lib.platforms.unix;
  };
})

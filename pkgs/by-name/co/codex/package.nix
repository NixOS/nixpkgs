{
  lib,
  stdenv,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  alsa-lib,
  bubblewrap,
  clang,
  cmake,
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
  version = "0.162.1";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = finalAttrs.buildCommit;
    hash = "sha256-vYVQoXQdaK0bejUzcpf9uVrzNWWWAct9AsO/t261FAs=";
  };

  # Matching client/helper stamps; build_id() requires a full commit SHA.
  buildCommit = "092d3acd6bec3e3a14bdc7e7a2810ab628ab759d";

  sourceRoot = "${finalAttrs.src.name}/codex-rs";

  cargoHash = "sha256-UTu+ws1DqL375C+1jaVI9HBqDHnTuAQr7/h1rSzsEzg=";
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
  cargoCheckFlags = [
    "--package"
    "codex-cli"
    "--package"
    "codex-code-mode-host"
  ]
  ++ lib.optionals supportsVoice [
    "--package"
    "codex-voice-host"
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

  # NOTE: part of the test suite requires access to networking, local shells,
  # apple system configuration, etc. since this is a very fast moving target
  # (for now), with releases happening every other day, constantly figuring out
  # which tests need to be skipped, or finding workarounds, was too burdensome,
  # and in practice not adding any real value. this decision may be reversed in
  # the future once this software stabilizes.
  doCheck = false;

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

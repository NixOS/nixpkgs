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
  lld,
  makeBinaryWrapper,
  nix-update-script,
  pkg-config,
  openssl,
  ripgrep,
  versionCheckHook,
  writeText,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  _experimental-update-script-combinators,
}:
let
  voiceSupport =
    stdenv.hostPlatform.isDarwin || (stdenv.hostPlatform.isLinux && stdenv.hostPlatform.isGnu);
  voiceRuntime =
    let
      pluginDirectory = if stdenv.hostPlatform.isDarwin then "plugins" else "lib/gstreamer-1.0";
      pluginSuffix = stdenv.hostPlatform.extensions.sharedLibrary;
      plugin = package: name: {
        source = "${lib.getLib package}/lib/gstreamer-1.0/libgst${name}${pluginSuffix}";
        target = "${pluginDirectory}/libgst${name}${pluginSuffix}";
      };
      coreSuffix = if stdenv.hostPlatform.isDarwin then "0.dylib" else "so.0";
    in
    [
      {
        source = "${lib.getLib gst_all_1.gstreamer}/lib/libgstreamer-1.0.${coreSuffix}";
        target = "lib/libgstreamer-1.0.${coreSuffix}";
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
  version = "0.156.1";
  buildCommit = "b412ff32c417f855c2b2d1581b77058eed87c84b";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    rev = finalAttrs.buildCommit;
    hash = "sha256-H53f57hmnyCtn5yPxtBe/A92qyQyzQBeU/vK2qSBrvI=";
  };

  sourceRoot = "${finalAttrs.src.name}/codex-rs";

  cargoHash = "sha256-W87rX/W2J1pwqNrihX+Rj6DfagoZYuB6C+l/S4BhyJM=";
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

  patches = [ ./nix-voice-runtime.patch ];

  # Match upstream's release build for the codex binary, plus its
  # codex-code-mode-host runtime companion for out-of-process V8 execution.
  cargoBuildFlags = [
    "--package"
    "codex-cli"
    "--package"
    "codex-code-mode-host"
  ]
  ++ lib.optionals voiceSupport [
    "--package"
    "codex-voice-host"
  ];
  cargoCheckFlags = [
    "--package"
    "codex-cli"
    "--package"
    "codex-code-mode-host"
  ]
  ++ lib.optionals voiceSupport [
    "--package"
    "codex-voice-host"
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
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [
    libclang
    openssl
  ]
  ++ lib.optionals voiceSupport [
    gst_all_1.gstreamer
    gst_all_1.gst-plugins-base
    gst_all_1.gst-plugins-good
    libopus
  ]
  ++ lib.optionals (voiceSupport && stdenv.hostPlatform.isLinux) [
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
  // lib.optionalAttrs voiceSupport {
    NIX_CODEX_VOICE_RUNTIME_ROOTS = lib.concatStringsSep ":" [
      (toString (lib.getLib gst_all_1.gstreamer))
      (toString (lib.getLib gst_all_1.gst-plugins-base))
      (toString (lib.getLib gst_all_1.gst-plugins-good))
    ];
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
  ''
  + lib.optionalString voiceSupport ''
    install -d $out/codex-resources/voice/bin
    mv $out/bin/codex-voice-host $out/codex-resources/voice/bin/
    ${lib.concatMapStringsSep "\n" (link: ''
      install -d $out/codex-resources/voice/${builtins.dirOf link.target}
      ln -s ${link.source} $out/codex-resources/voice/${link.target}
    '') voiceRuntime}
  ''
  + lib.optionalString installShellCompletions ''
    installShellCompletion --cmd codex \
      --bash <($out/bin/codex completion bash) \
      --fish <($out/bin/codex completion fish) \
      --zsh <($out/bin/codex completion zsh)
  '';

  postFixup = ''
    wrapProgram $out/bin/codex --prefix PATH : ${
      lib.makeBinPath ([ ripgrep ] ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap ])
    }
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

  passthru.tests = lib.optionalAttrs voiceSupport {
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

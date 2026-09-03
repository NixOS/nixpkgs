{
  lib,
  stdenv,
  callPackage,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  bubblewrap,
  clang,
  cmake,
  gitMinimal,
  libcap,
  libclang,
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
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
  _experimental-update-script-combinators,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "open-interpreter";
  version = "0.0.40";

  src = fetchFromGitHub {
    owner = "openinterpreter";
    repo = "openinterpreter";
    tag = "rust-v${finalAttrs.version}";
    hash = "sha256-sdYloCCBNPut67p6HYjUHLCdt0JGnHBMD/UDpplevus=";
  };

  sourceRoot = "${finalAttrs.src.name}/codex-rs";

  cargoHash = "sha256-LbXflYvKPNvV7Uxk/aUxjcd8Ik8W8BfOxwrH3tYSuM4=";

  __structuredAttrs = true;

  # Match upstream's release build for the interpreter binary, plus its
  # codex-code-mode-host runtime companion for out-of-process V8 execution.
  cargoBuildFlags = [
    "--package"
    "codex-cli"
    "--package"
    "codex-code-mode-host"
  ];
  cargoCheckFlags = [
    "--package"
    "codex-cli"
    "--package"
    "codex-code-mode-host"
  ];

  postPatch = ''
    substituteInPlace Cargo.toml \
      --replace-fail 'lto = "thin"' "" \
      --replace-fail 'codegen-units = 4' ""

    # Completions are emitted under the hardcoded upstream Codex name; every
    # other user-facing string already derives it from the active product.
    substituteInPlace cli/src/main.rs \
      --replace-fail 'let name = "codex";' 'let name = product_command_name();'
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
  ++ lib.optionals stdenv.hostPlatform.isLinux [
    libcap
  ];

  # NOTE: set LIBCLANG_PATH so bindgen can locate libclang, and adjust
  # warning-as-error flags to avoid known false positives (GCC's
  # stringop-overflow in BoringSSL's a_bitstr.cc) while keeping Clang's
  # character-conversion warning-as-error disabled.
  env = {
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
  }
  // lib.optionalAttrs stdenv.hostPlatform.isDarwin {
    # Link with lld on Darwin. nixpkgs' classic open-source ld64 fails to insert
    # ARM64 branch thunks for this binary, producing `b(l) ARM64 branch out of range`.
    NIX_CFLAGS_LINK = "-fuse-ld=${lib.getExe' lld "ld64.lld"}";
  };

  # NOTE: part of the test suite requires access to networking, local shells and
  # apple system configuration. This is inherited from Codex upstream, which is
  # packaged with checks disabled for the same reason.
  doCheck = false;

  postInstall = ''
    # The fork keeps Codex's crate and binary names internally; `interpreter`
    # (aliased `i`) is the product command, and argv0 is what selects the
    # Open Interpreter branding at runtime.
    mv $out/bin/codex $out/bin/interpreter
    ln -s interpreter $out/bin/i

    # Internal log-tailing helper, too generic a name to put on PATH.
    rm $out/bin/logs_client
  ''
  + lib.optionalString installShellCompletions ''
    installShellCompletion --cmd interpreter \
      --bash <($out/bin/interpreter completion bash) \
      --fish <($out/bin/interpreter completion fish) \
      --zsh <($out/bin/interpreter completion zsh)
  '';

  postFixup = ''
    wrapProgram $out/bin/interpreter --prefix PATH : ${
      lib.makeBinPath ([ ripgrep ] ++ lib.optionals stdenv.hostPlatform.isLinux [ bubblewrap ])
    }
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru.updateScript = _experimental-update-script-combinators.sequence [
    (nix-update-script {
      extraArgs = [
        "--use-github-releases"
        "--version-regex"
        "^rust-v(\\d+\\.\\d+\\.\\d+)$"
      ];
    })
    ./update-librusty.sh
  ];

  meta = {
    description = "Coding agent for open models, running in your terminal";
    homepage = "https://github.com/openinterpreter/openinterpreter";
    changelog = "https://github.com/openinterpreter/openinterpreter/blob/rust-v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "interpreter";
    maintainers = with lib.maintainers; [ happysalada ];
    platforms = lib.platforms.unix;
  };
})

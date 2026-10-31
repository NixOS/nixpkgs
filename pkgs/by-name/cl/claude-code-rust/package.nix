{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  fetchNpmDeps,
  npmHooks,
  nodejs,
  git,
  bun,
  claude-code,
  installShellFiles,
  makeBinaryWrapper,
  versionCheckHook,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "claude-code-rust";
  version = "0.16.1";

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "srothgan";
    repo = "claude-code-rust";
    tag = "v${finalAttrs.version}";
    hash = "sha256-/wTxbCGz+QXNsP4dJwZyMip2BQ2Y4EAyMWtRumx4Gas=";
  };

  cargoHash = "sha256-ktfjg9Ff0v4ymSkS0LlX8iJcJAOdmA0hCsIqpMPERFA=";

  # The TUI talks to Claude Code through a TypeScript bridge (agent-sdk/)
  # that runs on Bun and imports @anthropic-ai/claude-agent-sdk at runtime.
  npmRoot = "agent-sdk";
  npmDeps = fetchNpmDeps {
    name = "${finalAttrs.pname}-npm-deps-${finalAttrs.version}";
    inherit (finalAttrs) src;
    sourceRoot = "${finalAttrs.src.name}/agent-sdk";
    hash = "sha256-Y/JrkMdtdZMc6aAFwVDz58U3sp35kGkyJN1FXIuPzmo=";
  };

  nativeBuildInputs = [
    nodejs
    npmHooks.npmConfigHook
    installShellFiles
    makeBinaryWrapper
  ];

  preBuild = ''
    npm run build --prefix agent-sdk
  '';

  # tests/terminal_resize.rs points the binary at a fake bridge through
  # CLAUDE_RS_AGENT_BRIDGE_RUNTIME, which only debug builds read; upstream CI
  # runs `cargo test` in the debug profile as well. The fake bridge runs on
  # the nodejs from nativeBuildInputs.
  checkType = "debug";
  nativeCheckInputs = [ git ];

  # A release build finds its bridge script (agent-sdk/dist/bridge.js) and its
  # JavaScript runtime (a file named claude-rs-bridge-bun) only by walking the
  # ancestors of its canonicalised executable; the runtime override variable is
  # honoured in debug builds only. So the real binary lives in libexec next to
  # both, and $out/bin holds a wrapper.
  postInstall = ''
    app=$out/libexec/claude-code-rust
    mkdir -p $app/agent-sdk
    mv $out/bin/claude-rs $app/claude-rs

    pushd agent-sdk
    # The optional @anthropic-ai/claude-agent-sdk-<platform> packages carry a
    # bundled native Claude Code; the wrapper points the SDK at nixpkgs'
    # claude-code instead, so they are pruned along with the dev toolchain.
    npm prune --omit=dev --omit=optional --no-save
    # The bridge runs on Bun; these Node CLIs are never used, and their
    # patched shebangs would pull nodejs into the closure.
    rm -r node_modules/.bin node_modules/@anthropic-ai/sdk/bin node_modules/which/bin
    cp -r dist node_modules package.json $app/agent-sdk/
    popd
    ln -s ${lib.getExe bun} $app/claude-rs-bridge-bun

    # Update checks are disabled because the package is updated through Nix.
    # claude-code is appended to PATH for the slash commands and usage view
    # that call `claude` directly; a claude earlier on PATH still wins there.
    makeBinaryWrapper $app/claude-rs $out/bin/claude-rs \
      --set-default CLAUDE_CODE_EXECUTABLE ${lib.getExe claude-code} \
      --set-default CLAUDE_RUST_NO_UPDATE_CHECK 1 \
      --suffix PATH : ${lib.makeBinPath [ claude-code ]}
  ''
  + lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    $app/claude-rs man man
    installManPage man/*
    installShellCompletion --cmd claude-rs \
      --bash <($app/claude-rs completions bash) \
      --fish <($app/claude-rs completions fish) \
      --zsh <($app/claude-rs completions zsh)
  '';

  disallowedReferences = [ nodejs ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Native Rust terminal interface for Claude Code";
    homepage = "https://github.com/srothgan/claude-code-rust";
    changelog = "https://github.com/srothgan/claude-code-rust/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ayush5harma ];
    mainProgram = "claude-rs";
    # Limited to the platforms claude-code is packaged for.
    platforms = [
      "aarch64-darwin"
      "aarch64-linux"
      "x86_64-linux"
    ];
  };
})

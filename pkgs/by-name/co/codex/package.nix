{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  installShellFiles,
  makeBinaryWrapper,
  nix-update-script,
  pkg-config,
  openssl,
  ripgrep,
  versionCheckHook,
  installShellCompletions ? stdenv.buildPlatform.canExecute stdenv.hostPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "codex";
  version = "0.63.0";

  src = fetchFromGitHub {
    owner = "openai";
    repo = "codex";
    tag = "rust-v${finalAttrs.version}";
    hash = "sha256-CWISGlSpS0A2yuXNC11L+5iT5Z9heHqkcIGQDJoUWFE=";
  };

  sourceRoot = "${finalAttrs.src.name}/codex-rs";

  cargoHash = "sha256-S6KCJ/b2fY8ydCoR+BfhEV4bbcgwQ6V0xHA9Mbl87jo=";

  nativeBuildInputs = [
    installShellFiles
    makeBinaryWrapper
    pkg-config
  ];

  buildInputs = [ openssl ];

  # NOTE: part of the test suite requires access to networking, local shells,
  # apple system configuration, etc. since this is a very fast moving target
  # (for now), with releases happening every other day, constantly figuring out
  # which tests need to be skipped, or finding workarounds, was too burdensome,
  # and in practice not adding any real value. this decision may be reversed in
  # the future once this software stabilizes.
  doCheck = false;

  postInstall = lib.optionalString installShellCompletions ''
    installShellCompletion --cmd codex \
      --bash <($out/bin/codex completion bash) \
      --fish <($out/bin/codex completion fish) \
      --zsh <($out/bin/codex completion zsh)
  '';

  postFixup = ''
    wrapProgram $out/bin/codex --prefix PATH : ${lib.makeBinPath [ ripgrep ]}
  '';

  doInstallCheck = true;
  nativeInstallCheckInputs = [ versionCheckHook ];

  passthru = {
    updateScript = nix-update-script {
      extraArgs = [
        "--version-regex"
        "^rust-v(\\d+\\.\\d+\\.\\d+)$"
      ];
    };
  };

  meta = {
    description = "Lightweight coding agent that runs in your terminal";
    homepage = "https://github.com/openai/codex";
    changelog = "https://raw.githubusercontent.com/openai/codex/refs/tags/rust-v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    mainProgram = "codex";
    maintainers = with lib.maintainers; [
      malo
      delafthi
    ];
    platforms = lib.platforms.unix;
  };
})

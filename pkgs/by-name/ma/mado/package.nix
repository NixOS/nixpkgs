{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  installShellFiles,
  oniguruma,
  rust-jemalloc-sys,
  stdenv,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mado";
  version = "0.3.1";

  src = fetchFromGitHub {
    owner = "akiomik";
    repo = "mado";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UpkzUeFSLpTjTcf5yEpQDJVDZXL9DEuvw0Hx4r0hG7o=";
  };

  cargoHash = "sha256-3Wtr+o59SqAjDPLZxTcjK92FF/+O0eXwehnJIRfV2zQ=";

  nativeBuildInputs = [
    pkg-config
    installShellFiles
  ];

  buildInputs = [
    oniguruma
    rust-jemalloc-sys
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  postInstall = lib.optionalString (stdenv.buildPlatform.canExecute stdenv.hostPlatform) ''
    installShellCompletion --cmd mado \
      --bash <($out/bin/mado generate-shell-completion bash) \
      --zsh <($out/bin/mado generate-shell-completion zsh) \
      --fish <($out/bin/mado generate-shell-completion fish)
  '';

  checkFlags = [
    #   # seem to be slightly broken inside of the build sandbox
    "--skip=check_empty_stdin_with_file"
    "--skip=check_stdin"
    "--skip=check_stdin_with_file"
    "--skip=generate_shell_completion_invalid"
    "--skip=unknown_command"
  ];

  meta = {
    description = "Markdown linter written in Rust";
    homepage = "https://github.com/akiomik/mado";
    changelog = "https://github.com/akiomik/mado/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jasonxue1 ];
    mainProgram = "mado";
  };
})

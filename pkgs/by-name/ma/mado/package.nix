{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  oniguruma,
  rust-jemalloc-sys,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "mado";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "akiomik";
    repo = "mado";
    tag = "v${finalAttrs.version}";
    hash = "sha256-wAuV4w0dKfUbJVLTdp59/u4y13SPy3wkRfTlpvyE/zY=";
  };

  cargoHash = "sha256-fkalUnPkjjzhLaACh+WQP4tG5VzZ7wmrh5T1DVgSDwM=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    oniguruma
    rust-jemalloc-sys
  ];

  env = {
    RUSTONIG_SYSTEM_LIBONIG = true;
  };

  checkFlags = [
    # seem to be slightly broken inside of the build sandbox
    "--skip=check_empty_stdin_with_file"
    "--skip=check_stdin"
    "--skip=check_stdin_with_file"
    "--skip=generate_shell_completion_invalid"
    "--skip=unknown_command"
  ];

  meta = {
    description = "A fast Markdown linter written in Rust";
    homepage = "https://github.com/akiomik/mado";
    changelog = "https://github.com/akiomik/mado/blob/v${finalAttrs.version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ jasonxue1 ];
    mainProgram = "mado";
  };
})

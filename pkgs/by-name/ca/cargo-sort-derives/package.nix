{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sort-derives";
  version = "0.12.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "cargo-sort-derives";
    tag = "v${finalAttrs.version}";
    hash = "sha256-91sfRTMcI2/MyTrv+uJmhqfL4KUAc6//yzRR9FxvPHo=";
  };

  cargoHash = "sha256-kQTAYBb/xhrfO3PSJvnZrZKr6B3fgtlElf1mNCSf7eg=";

  meta = {
    description = "Cargo subcommand to sort derive attributes";
    mainProgram = "cargo-sort-derives";
    homepage = "https://lusingander.github.io/cargo-sort-derives/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sebimarkgraf ];
  };
})

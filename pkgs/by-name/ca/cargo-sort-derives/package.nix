{
  fetchFromGitHub,
  lib,
  rustPlatform,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-sort-derives";
  version = "0.13.0";

  src = fetchFromGitHub {
    owner = "lusingander";
    repo = "cargo-sort-derives";
    tag = "v${finalAttrs.version}";
    hash = "sha256-o92jmQ+AYZIadVUMqsZdAq7x1Y4HneWx3RYEVKTVJyM=";
  };

  cargoHash = "sha256-DPjwCzP7nsqJjsERHO3YMUEXbU7TjUTZc8Jo1R9XThg=";

  meta = {
    description = "Cargo subcommand to sort derive attributes";
    mainProgram = "cargo-sort-derives";
    homepage = "https://lusingander.github.io/cargo-sort-derives/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ sebimarkgraf ];
  };
})

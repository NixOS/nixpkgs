{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "adrs";
  version = "0.10.0";

  src = fetchFromGitHub {
    owner = "joshrotenberg";
    repo = "adrs";
    tag = "v${finalAttrs.version}";
    hash = "sha256-sYeJ+5gAZXjKiwHLcS2iiBM3OZUWXo6lS0OxiNLtBXM=";
  };

  cargoHash = "sha256-jI0FAZ+QzqTTiRKcnfo1Uh0J1rFWNqNvSLQU/GIjLbc=";

  meta = {
    description = "Command-line tool for managing Architectural Decision Records";
    homepage = "https://github.com/joshrotenberg/adrs";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [ dannixon ];
    mainProgram = "adrs";
  };
})

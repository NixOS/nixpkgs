{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-tally";
  version = "1.0.82";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-5eG8SaNjNq2jFOoclu8DI9HtPGS9DZWaMittYxLRKZg=";
  };

  cargoHash = "sha256-PC2FrHc7WYzZdZGuH9SLQy86X/dG/aREWtjFs62CtaM=";

  meta = {
    description = "Graph the number of crates that depend on your crate over time";
    mainProgram = "cargo-tally";
    homepage = "https://github.com/dtolnay/cargo-tally";
    changelog = "https://github.com/dtolnay/cargo-tally/releases/tag/${finalAttrs.version}";
    license =
      with lib.licenses;
      OR [
        asl20
        mit
      ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})

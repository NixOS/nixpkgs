{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-tally";
  version = "1.0.74";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-JZtELsvxOx6FFQ+l8fbhPnR8Tt+sQWV4fGsoS8ue4QY=";
  };

  cargoHash = "sha256-Vn5OSJNpwE3rjs+tYX784o1Khrcf4f21dvb8Yn/c9bY=";

  meta = {
    description = "Graph the number of crates that depend on your crate over time";
    mainProgram = "cargo-tally";
    homepage = "https://github.com/dtolnay/cargo-tally";
    changelog = "https://github.com/dtolnay/cargo-tally/releases/tag/${finalAttrs.version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})

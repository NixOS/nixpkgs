{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-toml-lint";
  version = "0.1.1";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-U3y9gnFvkqJmyFqRAUQorJQY0iRzAE9UUXzFmgZIyaM=";
  };

  cargoHash = "sha256-ymf91oCLOY5vo1pncCT83j3k8wyLEwAl3/8lnAyPdzI=";

  meta = {
    description = "Simple linter for Cargo.toml manifests";
    mainProgram = "cargo-toml-lint";
    homepage = "https://github.com/fuellabs/cargo-toml-lint";
    changelog = "https://github.com/fuellabs/cargo-toml-lint/releases/tag/v${version}";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      mitchmindtree
      matthiasbeyer
    ];
  };
}

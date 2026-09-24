{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-lock";
  version = "11.1.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-FyFCNXOn30K5zbQUpKNZKGIKrwurwl/Zvi+7ELg6DwE=";
  };

  cargoHash = "sha256-Cco9KksibnQMeqyrNnr6ImxFZKo/OyVc2jL7pKMKYTk=";

  buildFeatures = [ "cli" ];

  meta = {
    description = "Self-contained Cargo.lock parser with graph analysis";
    mainProgram = "cargo-lock";
    homepage = "https://github.com/rustsec/rustsec/tree/main/cargo-lock";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-lock/v${finalAttrs.version}/cargo-lock/CHANGELOG.md";
    license = with lib.licenses; [
      asl20 # or
      mit
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
    ];
  };
})

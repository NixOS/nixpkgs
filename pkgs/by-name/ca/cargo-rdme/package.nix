{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-rdme";
  version = "1.4.9";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-ostDwjj93WhDfBKJY9xpKd74knQi9z9UFb5Q84waHuM=";
  };

  cargoHash = "sha256-pk7tYvN2Drn+Gpk170ITsAF38dVWjk+RBfrnb0YpZc4=";

  meta = {
    description = "Cargo command to create the README.md from your crate's documentation";
    mainProgram = "cargo-rdme";
    homepage = "https://github.com/orium/cargo-rdme";
    changelog = "https://github.com/orium/cargo-rdme/blob/v${version}/release-notes.md";
    license = with lib.licenses; [ mpl20 ];
    maintainers = with lib.maintainers; [ GoldsteinE ];
  };
}

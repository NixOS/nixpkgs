{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-autoinherit";
  version = "0.1.3";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-jhi+7lR8JiZDgYYDBBioCPYyKwDz5zH6NkP/yOxpFAg=";
  };

  cargoHash = "sha256-8uJZ/ZHb2TnFJqgBsF1HBAWc+MNZoxaxXInp1T3Zd34=";

  meta = with lib; {
    description = "A Cargo subcommand to automatically DRY up your `Cargo.toml` manifests in a workspace";
    homepage = "https://github.com/mainmatter/cargo-autoinherit";
    license = with licenses; [asl20 mit];
    maintainers = with maintainers; [shaddydc];
  };
}

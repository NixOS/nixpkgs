{
  lib,
  rustPlatform,
  fetchCrate,
}:
rustPlatform.buildRustPackage rec {
  pname = "cargo-autoinherit";
  version = "0.1.4";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-4ETE7fgleCTcBLfKnBfKcfcB8vMTE5BhzIKsj+3UR+k=";
  };

  cargoHash = "sha256-9hhrVkC1xB2E/vatkiM4PIJyXq+0GDoqlgXZXc8WehU=";

  meta = with lib; {
    description = "A Cargo subcommand to automatically DRY up your `Cargo.toml` manifests in a workspace";
    homepage = "https://github.com/mainmatter/cargo-autoinherit";
    license = with licenses; [asl20 mit];
    maintainers = with maintainers; [shaddydc];
  };
}

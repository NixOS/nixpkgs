{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.75";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-FETYJrx5+yNOzMVIgJQ0yNLi2PB7cA128n8hAXIhx3E=";
  };

  cargoHash = "sha256-4dMBGCEoLICnTjrTeTiXBE+AMH2siT9WLqdUfWN4UkU=";

  meta = {
    description = "Cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    mainProgram = "cargo-chef";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ kkharji ];
  };
}

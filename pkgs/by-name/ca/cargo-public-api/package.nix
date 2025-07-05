{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  curl,
  openssl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-public-api";
  version = "0.48.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-QNv1aVdGZUSgiq4nJ5epuioZOJCKsss7GKYlsf98CJc=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-XzMNQbDP1dCs1vCEGgOBLR0xw8RSXupMdX5V0SPtvy4=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [
    curl
    openssl
  ];

  # Tests fail
  doCheck = false;

  meta = {
    description = "List and diff the public API of Rust library crates between releases and commits. Detect breaking API changes and semver violations";
    mainProgram = "cargo-public-api";
    homepage = "https://github.com/Enselic/cargo-public-api";
    changelog = "https://github.com/Enselic/cargo-public-api/releases/tag/v${version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ matthiasbeyer ];
  };
}

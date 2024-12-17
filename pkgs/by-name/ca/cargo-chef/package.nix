{
  lib,
  rustPlatform,
  fetchCrate,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-chef";
  version = "0.1.68";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-NTFrNSEIzHppwOOjI3VadjhdV6EgGUmJzyX5JmTsJoI=";
  };

  cargoHash = "sha256-DoIkK/tj3AYt0vm7u7f4SmgOKbdQZv3ZunMFT68+37E=";

  meta = with lib; {
    description = "Cargo-subcommand to speed up Rust Docker builds using Docker layer caching";
    mainProgram = "cargo-chef";
    homepage = "https://github.com/LukeMathWalker/cargo-chef";
    license = licenses.mit;
    maintainers = with maintainers; [ kkharji ];
  };
}

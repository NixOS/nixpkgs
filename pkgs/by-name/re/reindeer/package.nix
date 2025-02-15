{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "reindeer";
  version = "2025.02.03.00";

  src = fetchFromGitHub {
    owner = "facebookincubator";
    repo = "reindeer";
    tag = "v${version}";
    hash = "sha256-dEtwCGtS8JE24aBGIHvTgUimNccDmjCCEjX5zA1I4bU=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-mhqT0vZRrmYN6UR9omEjQa/1JJ2pI3yu5HveMlbvvR0=";

  nativeBuildInputs = [ pkg-config ];

  buildInputs = [ openssl ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Reindeer is a tool which takes Rust Cargo dependencies and generates Buck build rules";
    mainProgram = "reindeer";
    homepage = "https://github.com/facebookincubator/reindeer";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ nickgerace ];
  };
}

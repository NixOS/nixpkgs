{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-audit";
  version = "0.22.0";

  src = fetchCrate {
    inherit pname version;
    hash = "sha256-Ha2yVyu9331NaqiW91NEwCTIeW+3XPiqZzmatN5KOws=";
  };

  cargoHash = "sha256-f8nrW1l7UA8sixwqXBD1jCJi9qyKC5tNl/dWwCt41Lk=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
  ];

  buildFeatures = [ "fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    mainProgram = "cargo-audit";
    homepage = "https://rustsec.org";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/v${version}/cargo-audit/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      basvandijk
      jk
    ];
  };
}

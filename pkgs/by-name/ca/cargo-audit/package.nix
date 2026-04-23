{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-audit";
  version = "0.22.1";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-/K84iYr3mRNH8lbqHHa7Tsh7M3ykQ2hs6T1k/qrSsnA=";
  };

  cargoHash = "sha256-Hr3CliJeb9ljHylx8mjkGyf4ybX79Fmt6CaFb6FMRts=";

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
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/v${finalAttrs.version}/cargo-audit/CHANGELOG.md";
    license = with lib.licenses; [
      mit # or
      asl20
    ];
    maintainers = with lib.maintainers; [
      basvandijk
      jk
    ];
  };
})

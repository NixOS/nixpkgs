{
  lib,
  rustPlatform,
  fetchCrate,
  pkg-config,
  openssl,
  aws-lc,
  zlib,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-audit";
  version = "0.23.0";

  src = fetchCrate {
    inherit (finalAttrs) pname version;
    hash = "sha256-SePgSuYYc/5ZNgC8iKNW2wfEi9kejpOkIqVCyBWbgs4=";
  };

  cargoHash = "sha256-2zKR/8BbzvRCExknD2zaJJTCRhnxzgJzKdhk6fbvtZg=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
    zlib
    aws-lc
  ];

  buildFeatures = [ "fix" ];

  # The tests require network access which is not available in sandboxed Nix builds.
  doCheck = false;

  meta = {
    description = "Audit Cargo.lock files for crates with security vulnerabilities";
    mainProgram = "cargo-audit";
    homepage = "https://rustsec.org";
    changelog = "https://github.com/rustsec/rustsec/blob/cargo-audit/v${finalAttrs.version}/cargo-audit/CHANGELOG.md";
    license =
      with lib.licenses;
      OR [
        mit
        asl20
      ];
    maintainers = with lib.maintainers; [
      basvandijk
      jk
    ];
  };
})

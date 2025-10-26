{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  curl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-cyclonedx";
  version = "0.5.8";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-rust-cargo";
    rev = "cargo-cyclonedx-${finalAttrs.version}";
    hash = "sha256-TLERyZ854KVIeTYu7WT+U/K9YoUmk9bYX/fp3brLFrg=";
  };

  cargoHash = "sha256-uaZ79/4AUe3zx2uuqLEO79QrzqgXaegBxtRmnmM/rOw=";

  # Test suite is broken since rustc 1.90, see:
  # https://github.com/CycloneDX/cyclonedx-rust-cargo/issues/807
  doCheck = false;

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
  ];

  meta = {
    description = "Creates CycloneDX Software Bill of Materials (SBOM) from Rust (Cargo) projects";
    mainProgram = "cargo-cyclonedx";
    longDescription = ''
      The CycloneDX module for Rust (Cargo) creates a valid CycloneDX Software
      Bill-of-Material (SBOM) containing an aggregate of all project
      dependencies. CycloneDX is a lightweight SBOM specification that is
      easily created, human and machine readable, and simple to parse.
    '';
    homepage = "https://github.com/CycloneDX/cyclonedx-rust-cargo";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ nikstur ];
  };
})

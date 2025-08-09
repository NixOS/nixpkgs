{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  openssl,
  curl,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-cyclonedx";
  version = "0.5.7";

  src = fetchFromGitHub {
    owner = "CycloneDX";
    repo = "cyclonedx-rust-cargo";
    rev = "${pname}-${version}";
    hash = "sha256-T/9eHI2P8eCZAqMTeZz1yEi5nljQWfHrdNiU3h3h74U=";
  };

  cargoHash = "sha256-deczbMPeJsnmXbVB60stKhJJZRIIwjY5vExS3x3b6aU=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    openssl
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    curl
  ];

  meta = with lib; {
    description = "Creates CycloneDX Software Bill of Materials (SBOM) from Rust (Cargo) projects";
    mainProgram = "cargo-cyclonedx";
    longDescription = ''
      The CycloneDX module for Rust (Cargo) creates a valid CycloneDX Software
      Bill-of-Material (SBOM) containing an aggregate of all project
      dependencies. CycloneDX is a lightweight SBOM specification that is
      easily created, human and machine readable, and simple to parse.
    '';
    homepage = "https://github.com/CycloneDX/cyclonedx-rust-cargo";
    license = licenses.asl20;
    maintainers = with maintainers; [ nikstur ];
  };
}

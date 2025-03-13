{ lib, rustPlatform, fetchFromGitHub, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.92";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    hash = "sha256-lBFIrBzRyt8uSXj3xrxEsvM4Vdfy1dnc55GvzCge7H4=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-z9yw5yTxDBbMPQqYpXyI4YCk/OJTWLPO299rtsq2XmE=";

  cargoBuildFlags = [ "-p" "cargo-nextest" ];
  cargoTestFlags = [ "-p" "cargo-nextest" ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Next-generation test runner for Rust projects";
    mainProgram = "cargo-nextest";
    homepage = "https://github.com/nextest-rs/nextest";
    changelog = "https://nexte.st/CHANGELOG.html";
    license = with licenses; [ mit asl20 ];
    maintainers = with maintainers; [ ekleog figsoda matthiasbeyer ];
  };
}

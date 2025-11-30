{
  lib,
  fetchFromGitHub,
  rustPlatform,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-fuzz";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "rust-fuzz";
    repo = "cargo-fuzz";
    tag = version;
    hash = "sha256-wOzzPhAuCaJfp7uRZ1kPpzMIr03couRaIbbrjL0EyYo=";
  };

  cargoHash = "sha256-7HCdWkjIycVKZty760ZnLBtLOZ3gwPhwseIqxqf8xPQ=";

  doCheck = false;

  meta = with lib; {
    description = "Command line helpers for fuzzing";
    mainProgram = "cargo-fuzz";
    homepage = "https://github.com/rust-fuzz/cargo-fuzz";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      ekleog
      matthiasbeyer
    ];
  };
}

{ lib, rustPlatform, fetchFromGitHub, nix-update-script }:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.82";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    hash = "sha256-dtZGTKC9C9akjcD56I2iafPnPEd5MKgoCjB0Rkc53o4=";
  };

  cargoHash = "sha256-3V9o4DmGG4gkqrRfZkcKTJe2Ld2ON9Ne2XJMOVUeFaA=";

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

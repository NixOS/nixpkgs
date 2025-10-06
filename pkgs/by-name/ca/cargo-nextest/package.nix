{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.104";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    hash = "sha256-CZNnOuMF5P3OgdwlAfUgbbXnDVm4IQ7P617Rblq0lgk=";
  };

  cargoHash = "sha256-jppSWm20Md++mxvs/h1pB1Bh/02muWqUm1DyR46nusY=";

  cargoBuildFlags = [
    "-p"
    "cargo-nextest"
  ];
  cargoTestFlags = [
    "-p"
    "cargo-nextest"
  ];

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Next-generation test runner for Rust projects";
    mainProgram = "cargo-nextest";
    homepage = "https://github.com/nextest-rs/nextest";
    changelog = "https://nexte.st/CHANGELOG.html";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      ekleog
      figsoda
      matthiasbeyer
    ];
  };
}

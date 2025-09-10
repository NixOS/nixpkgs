{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.103";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    hash = "sha256-n7VVfk6bvO97tY7woEYUAuxEay/fN6F0eWBDohqIBD0=";
  };

  cargoHash = "sha256-Nfm2KdyIgJ2rxYKn6r4lZbNkEWNQ+UAdkMiZAJfbzo8=";

  cargoBuildFlags = [
    "-p"
    "cargo-nextest"
  ];
  cargoTestFlags = [
    "-p"
    "cargo-nextest"
  ];

  passthru.updateScript = nix-update-script { };

  meta = with lib; {
    description = "Next-generation test runner for Rust projects";
    mainProgram = "cargo-nextest";
    homepage = "https://github.com/nextest-rs/nextest";
    changelog = "https://nexte.st/CHANGELOG.html";
    license = with licenses; [
      mit
      asl20
    ];
    maintainers = with maintainers; [
      ekleog
      figsoda
      matthiasbeyer
    ];
  };
}

{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.124";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    tag = "cargo-nextest-${version}";
    hash = "sha256-qvJ/dqbls2fVSPY++kYBIeiu14eDD8ORuvcD8dEtMZ8=";
  };

  # FIXME: we don't support dtrace probe generation on macOS until we have a dtrace build: https://github.com/NixOS/nixpkgs/pull/392918
  patches = lib.optionals stdenv.isDarwin [
    ./no-dtrace-macos.patch
  ];

  cargoHash = "sha256-3fZSXBP6vMh7GN2eY2upsvV/mTuDOcSovdsbcZBQA4U=";

  cargoBuildFlags = [
    "-p"
    "cargo-nextest"
  ];
  cargoTestFlags = [
    "-p"
    "cargo-nextest"
  ];

  passthru.updateScript = nix-update-script {
    extraArgs = [ "--version-regex=^cargo-nextest-([0-9.]+)$" ];
  };

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
      matthiasbeyer
      chrjabs
    ];
  };
}

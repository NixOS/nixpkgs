{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-nextest";
  version = "0.9.108";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    rev = "cargo-nextest-${version}";
    hash = "sha256-DY/FNtlNQg9Ym6PKo6UqSuWzGC3cDhbNU6MKTDxIaU4=";
  };

  # FIXME: we don't support dtrace probe generation on macOS until we have a dtrace build: https://github.com/NixOS/nixpkgs/pull/392918
  patches = lib.optionals stdenv.isDarwin [
    ./no-dtrace-macos.patch
  ];

  cargoHash = "sha256-uQH9d+9VByXe/lL4Ybz07p+iYWUhbATMBCu7mYKxOSE=";

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
      matthiasbeyer
    ];
  };
}

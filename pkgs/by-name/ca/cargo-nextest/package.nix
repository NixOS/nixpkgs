{
  lib,
  stdenv,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-nextest";
  version = "0.9.133";

  src = fetchFromGitHub {
    owner = "nextest-rs";
    repo = "nextest";
    tag = "cargo-nextest-${finalAttrs.version}";
    hash = "sha256-D8n7wvO9/MCSmvTkT6rht5+Zx9mOA/g8pajAVDVKGg8=";
  };

  # FIXME: we don't support dtrace probe generation on macOS until we have a dtrace build: https://github.com/NixOS/nixpkgs/pull/392918
  patches = lib.optionals stdenv.hostPlatform.isDarwin [
    ./no-dtrace-macos.patch
  ];

  cargoHash = "sha256-oftwiuKIGaxr44RnkMUAu/uSs47Sh5DqqDKZWRXhAN4=";

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
    changelog = "https://nexte.st/changelog/#${finalAttrs.version}";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = with lib.maintainers; [
      matthiasbeyer
      chrjabs
      figsoda
    ];
  };
})

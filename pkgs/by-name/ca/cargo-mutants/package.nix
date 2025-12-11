{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-mutants";
  version = "25.3.1";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
    tag = "v${finalAttrs.version}";
    hash = "sha256-T+BMLjp74IO71u/ftNfz67FPSt1LYCgsRP65gL0wScg=";
  };

  cargoHash = "sha256-Q9+p1MbjF2pyw254X+K6GQSLKNbqjmFXDyZjCI31b7s=";

  # too many tests require internet access
  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Mutation testing tool for Rust";
    mainProgram = "cargo-mutants";
    homepage = "https://github.com/sourcefrog/cargo-mutants";
    changelog = "https://github.com/sourcefrog/cargo-mutants/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.progrm_jarvis ];
  };
})

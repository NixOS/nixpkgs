{
  lib,
  rustPlatform,
  fetchFromGitHub,
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-mutants";
  version = "25.3.1";

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
    rev = "v${version}";
    hash = "sha256-T+BMLjp74IO71u/ftNfz67FPSt1LYCgsRP65gL0wScg=";
  };

  cargoHash = "sha256-Q9+p1MbjF2pyw254X+K6GQSLKNbqjmFXDyZjCI31b7s=";

  # too many tests require internet access
  doCheck = false;

  meta = with lib; {
    description = "Mutation testing tool for Rust";
    mainProgram = "cargo-mutants";
    homepage = "https://github.com/sourcefrog/cargo-mutants";
    changelog = "https://github.com/sourcefrog/cargo-mutants/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ maintainers.progrm_jarvis ];
  };
}

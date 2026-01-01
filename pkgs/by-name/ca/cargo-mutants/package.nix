{
  lib,
  rustPlatform,
  fetchFromGitHub,
<<<<<<< HEAD
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "cargo-mutants";
  version = "26.0.0";
=======
}:

rustPlatform.buildRustPackage rec {
  pname = "cargo-mutants";
  version = "25.3.1";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  src = fetchFromGitHub {
    owner = "sourcefrog";
    repo = "cargo-mutants";
<<<<<<< HEAD
    tag = "v${finalAttrs.version}";
    hash = "sha256-TtB+g5WgEqKP9sYJY3P/WDbpT9lD23RDi0/A7khwDIw=";
  };

  cargoHash = "sha256-FVwRS9OcQ0CjH8h10BzP7rTNHFIvefagIHMxVrfMaHo=";
=======
    rev = "v${version}";
    hash = "sha256-T+BMLjp74IO71u/ftNfz67FPSt1LYCgsRP65gL0wScg=";
  };

  cargoHash = "sha256-Q9+p1MbjF2pyw254X+K6GQSLKNbqjmFXDyZjCI31b7s=";
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

  # too many tests require internet access
  doCheck = false;

<<<<<<< HEAD
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
=======
  meta = with lib; {
    description = "Mutation testing tool for Rust";
    mainProgram = "cargo-mutants";
    homepage = "https://github.com/sourcefrog/cargo-mutants";
    changelog = "https://github.com/sourcefrog/cargo-mutants/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
>>>>>>> 4dbde0a9cadc (Fixed upon CodeReview)

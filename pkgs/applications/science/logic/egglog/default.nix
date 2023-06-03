{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "egglog";
  version = "unstable-2023-05-22";

  src = fetchFromGitHub {
    owner = "egraphs-good";
    repo = "egglog";
    rev = "5242b50051c339d55009860d4dff80125fdcedfd";
    hash = "sha256-N04CfITLEr4D4s6bUi0eRQdAVy6Ztq3Ml0365of7i0U=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "symbol_table-0.2.0" = "sha256-f9UclMOUig+N5L3ibBXou0pJ4S/CQqtaji7tnebVbis=";
      "symbolic_expressions-5.0.3" = "sha256-mSxnhveAItlTktQC4hM8o6TYjgtCUgkdZj7i6MR4Oeo=";
    };
  };

  meta = with lib; {
    description = "A fixpoint reasoning system that unifies Datalog and equality saturation";
    homepage = "https://github.com/egraphs-good/egglog";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "egg-smol";
  };
}

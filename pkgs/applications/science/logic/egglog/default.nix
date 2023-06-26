{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "egglog";
  version = "unstable-2023-06-11";

  src = fetchFromGitHub {
    owner = "egraphs-good";
    repo = "egglog";
    rev = "c7ef8b000caf7fa17f6127847db4b9c285c03f09";
    hash = "sha256-OGuqC/HgH7UhUhW5RU8nkqj6roPjXXOyVRHmnJdIolg=";
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
  };
}

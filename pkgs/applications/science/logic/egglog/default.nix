{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "egglog";
  version = "unstable-2023-09-12";

  src = fetchFromGitHub {
    owner = "egraphs-good";
    repo = "egglog";
    rev = "4d67f262a6f27aa5cfb62a2cfc7df968959105df";
    hash = "sha256-1mc7dW2pgaK4D7ZmlSHohb+6lcr7M9SRLUV/Dod8Rv0=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "egraph-serialize-0.1.0" = "sha256-sdkn7lmtmbLwAopabLWkrD6GjM3LIHseysuvwPz26G4=";
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

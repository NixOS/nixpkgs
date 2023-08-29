{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "egglog";
  version = "unstable-2023-08-23";

  src = fetchFromGitHub {
    owner = "egraphs-good";
    repo = "egglog";
    rev = "9e530381961a59524f2bbacd89973575b4e036d8";
    hash = "sha256-xzfa1Z7ibSO4D5zpprC7heaswA7Be5Qmb81XoDwANqw=";
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

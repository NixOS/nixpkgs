{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "egglog";
  version = "unstable-2023-08-09";

  src = fetchFromGitHub {
    owner = "egraphs-good";
    repo = "egglog";
    rev = "de31786679e3fa879e37c324e7eb54d76466f61f";
    hash = "sha256-mskFjDTkmHwaGWMpwW2DTD64vLvWGZJYgy9smEbhFwI=";
  };

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "egraph-serialize-0.1.0" = "sha256-1lDaoR/1TNFW+uaf3UdfDZgXlxyAb37Ij7yky16xCG8=";
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

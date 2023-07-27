{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage {
  pname = "egglog";
  version = "unstable-2023-07-19";

  src = fetchFromGitHub {
    owner = "egraphs-good";
    repo = "egglog";
    rev = "9fe03ad35a2a975a2c9140a641ba91266b7a72ce";
    hash = "sha256-9JeJJdZW8ecogReJzQrp3hFkK/pp/+pLxJMNREWuiyI=";
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

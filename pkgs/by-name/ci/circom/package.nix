{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "circom";
  version = "2.1.8";

  src = fetchFromGitHub {
    owner = "iden3";
    repo = "circom";
    rev = "v${version}";
    hash = "sha256-S+POXACM2XswpIaUze/wfVj2QYjRKJ2JGP1L88dfHA8=";
  };

  cargoHash = "sha256-gf9wWkeibj61Fh9Q+JqKVUVh2WpVBdM1Ei/Dg1/c+5E=";
  doCheck = false;

  meta = with lib; {
    description = "zkSnark circuit compiler";
    mainProgram = "circom";
    homepage = "https://github.com/iden3/circom";
    changelog = "https://github.com/iden3/circom/blob/${src.rev}/RELEASES.md";
    license = licenses.gpl3Only;
    maintainers = with maintainers; [ raitobezarius ];
  };
}

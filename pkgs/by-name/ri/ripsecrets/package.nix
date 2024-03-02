{ lib
, rustPlatform
, fetchFromGitHub
}:

rustPlatform.buildRustPackage rec {
  pname = "ripsecrets";
  version = "0.1.7";

  src = fetchFromGitHub {
    owner = "sirwart";
    repo = "ripsecrets";
    rev = "v${version}";
    hash = "sha256-NDSMxIq6eBXOv/mI662vsIIOfWQEzQ5fDGznC4+gFyE=";
  };

  cargoHash = "sha256-vp2gQUf6TWFkJ09STOlqlEB+jsGrVGAmix2eSgBDG/o=";

  meta = with lib; {
    description = "A command-line tool to prevent committing secret keys into your source code";
    homepage = "https://github.com/sirwart/ripsecrets";
    changelog = "https://github.com/sirwart/ripsecrets/blob/${src.rev}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "ripsecrets";
  };
}

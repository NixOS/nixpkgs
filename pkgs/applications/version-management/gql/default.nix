{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "gql";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-n0v7Mvs7JL3YRsNov4/beoUAW8B4oKjDiRa3QY65V/o=";
  };

  cargoHash = "sha256-dDjx84LPV3BHMzqyhJW73Z+0R4DlPsHhRlG62HGNxjI=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2
    zlib
  ];

  meta = with lib; {
    description = "A SQL like query language to perform queries on .git files";
    homepage = "https://github.com/AmrDeveloper/GQL";
    changelog = "https://github.com/AmrDeveloper/GQL/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "gitql";
  };
}

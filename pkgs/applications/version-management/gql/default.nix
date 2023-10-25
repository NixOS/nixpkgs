{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "gql";
  version = "0.4.1";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-d6uncWHq9bLDODFle7xij9YjhpiQPL7mmyFmVxmy8hY=";
  };

  cargoHash = "sha256-jR79xchMpib76oVnpy+UIbcwhDXvDPyl+jWmVPfXVog=";

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

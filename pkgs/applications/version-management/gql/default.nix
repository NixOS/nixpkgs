{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "gql";
  version = "0.9.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-A9gjCuWIRdNQhMjdRIH0B5cXGZAPQxK+qYSNI5WGZec=";
  };

  cargoHash = "sha256-aA7YPUKlBhfIBvT4D6zgZ8+lKNNazsVwGJC5VETAzOY=";

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

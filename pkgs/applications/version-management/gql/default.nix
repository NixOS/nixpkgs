{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, zlib
, cmake
}:

rustPlatform.buildRustPackage rec {
  pname = "gql";
  version = "0.25.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-Jys6pdHGIrgBrXnHm3P2PbTPBPiclQErEaUUQSRm1a0=";
  };

  cargoHash = "sha256-JT/Di4HEcXm03/1gVuaX+6JKn0aHAudwpf+gzXgRFfA=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    libgit2
    zlib
  ];

  meta = with lib; {
    description = "SQL like query language to perform queries on .git files";
    homepage = "https://github.com/AmrDeveloper/GQL";
    changelog = "https://github.com/AmrDeveloper/GQL/releases/tag/${src.rev}";
    license = licenses.mit;
    maintainers = with maintainers; [ figsoda ];
    mainProgram = "gitql";
  };
}

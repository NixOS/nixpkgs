{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_6
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "gql";
  version = "0.5.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-UTyP9ugUXiPMzkeIvPJUtORvcJ93YOBltglmlcym3sI=";
  };

  cargoHash = "sha256-AIt7Ns3vNrHQxJU7cSNr+h3tFGZ9hL1OMBqPHS61YUQ=";

  nativeBuildInputs = [
    pkg-config
  ];

  buildInputs = [
    libgit2_1_6
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

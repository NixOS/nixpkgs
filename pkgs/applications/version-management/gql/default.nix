{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2_1_6
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "gql";
  version = "0.6.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-eWupAfe2lOcOp8hC4sx8Wl1jaVZT4E99I5V9YsMcDZA=";
  };

  cargoHash = "sha256-O6Y+JOMpucrjvYAJZe2D97vODFXVysuiitXzMkfcSpI=";

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

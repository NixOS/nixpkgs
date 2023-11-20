{ lib
, rustPlatform
, fetchFromGitHub
, pkg-config
, libgit2
, zlib
}:

rustPlatform.buildRustPackage rec {
  pname = "gql";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-+f/OMU8fwwnlm8zTyE5XyIzfFwIB917tH9jaqSW8Skg=";
  };

  cargoHash = "sha256-A3o9OE8VO7z04WmbZL2rvlZRN/ZHOIGklKZQgiFSfxE=";

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

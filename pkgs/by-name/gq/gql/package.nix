{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  zlib,
  cmake,
}:

rustPlatform.buildRustPackage rec {
  pname = "gql";
  version = "0.33.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-I0ggNHvswuRhcUkndl0acEU3eOHGJqHB2csm9rXZ2sU=";
  };

  cargoHash = "sha256-yOf5kKHiPMvKi/+j6SCBZD1+gUBK4oR+H1JICPThwBA=";

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

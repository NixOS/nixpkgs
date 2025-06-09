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
  version = "0.38.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-/cTU+LBoXnMzNKd18nYoGkEN/cfUVQIDFBFQNrmdWuM=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-4sdbTcDDvA7MYMiTKKAWg0sYnBPeVj3eBCo7HTZYkUY=";

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

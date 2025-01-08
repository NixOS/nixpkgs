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
  version = "0.35.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = version;
    hash = "sha256-3aIZZvOmmGOa1+QHz7VrhLeEcyHSbsUMdD3PAqPpXVY=";
  };

  cargoHash = "sha256-IHh+7BdIZZOUyjJPHpuoUDfZDHUYoVQaMYjq1CCoxfM=";

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

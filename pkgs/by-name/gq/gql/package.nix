{
  lib,
  rustPlatform,
  fetchFromGitHub,
  pkg-config,
  libgit2,
  zlib,
  cmake,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "gql";
  version = "0.43.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = finalAttrs.version;
    hash = "sha256-fTmCL8b9Yp0DwgatGd7ODpq3z9b3Rqg/skqvjQkZvOU=";
  };

  cargoHash = "sha256-48nNiUCtFdTksgkLGDkhWp2Tfy4NGt6ka1ntC8UHXO0=";

  nativeBuildInputs = [
    pkg-config
    cmake
  ];

  buildInputs = [
    libgit2
    zlib
  ];

  meta = {
    description = "SQL like query language to perform queries on .git files";
    homepage = "https://github.com/AmrDeveloper/GQL";
    changelog = "https://github.com/AmrDeveloper/GQL/releases/tag/${finalAttrs.src.rev}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "gitql";
  };
})

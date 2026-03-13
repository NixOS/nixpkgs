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
  version = "0.42.0";

  src = fetchFromGitHub {
    owner = "AmrDeveloper";
    repo = "GQL";
    rev = finalAttrs.version;
    hash = "sha256-azonwUALsnGuEGu5AxE0uG8KBlN4tq+7VtnXykNLe6E=";
  };

  cargoHash = "sha256-6issWceEAZYCaW+zWDmBzjrTa3VOwZwBGTuag5nu4c0=";

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

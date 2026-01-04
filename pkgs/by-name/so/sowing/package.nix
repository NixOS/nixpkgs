{
  lib,
  stdenv,
  fetchFromBitbucket,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "sowing";
  version = "1.1.26.12";

  src = fetchFromBitbucket {
    owner = "petsc";
    repo = "pkg-sowing";
    rev = "v${finalAttrs.version}";
    hash = "sha256-ol0xNAnL7ULU1CiGCFZrV37IAV4z1bcWa0f+tuMhQC8=";
  };

  meta = {
    description = "Tools for documenting and improving portability";
    homepage = "https://wgropp.cs.illinois.edu/projects/software/sowing/";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ qbisi ];
    platforms = lib.platforms.unix;
  };
})

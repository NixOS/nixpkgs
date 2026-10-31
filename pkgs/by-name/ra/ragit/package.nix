{
  lib,
  rustPlatform,
  fetchFromGitHub,

  # Buildtime
  pkg-config,

  # Runtime
  fontconfig,
  freetype,
  openssl,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "ragit";
  version = "0.4.5";

  src = fetchFromGitHub {
    owner = "baehyunsol";
    repo = "ragit";
    tag = "v${finalAttrs.version}";
    hash = "sha256-Wh0Pwux9KfNAvmI2UuFmBBNuJU4H9MJAUTr5PbuYWfQ=";
  };

  # Add Cargo.lock since upstream doesn't include one
  postPatch = ''
    ln -s ${./Cargo.lock} Cargo.lock
  '';

  nativeBuildInputs = [
    pkg-config
    rustPlatform.bindgenHook
  ];

  buildInputs = [
    fontconfig
    freetype
    openssl
  ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      # Upstream uses pathfinder's HEAD – as of writing:
      # https://github.com/baehyunsol/ragit/blob/7f94f97d90dc949a89b5e30218ec735f34d43ac9/docs/build.md?plain=1#L44
      # https://github.com/servo/pathfinder/blob/3d0b936f4032435b9935e30850f830e89f751022/simd/Cargo.toml#L3
      "pathfinder_simd-0.5.5" = "sha256-96qVkQiYKY5tH9DchEUPRhIiql6joyl8Rhfzy2QvZ1M=";
    };
  };

  buildFeatures = [
    "csv"
    "korean"
    "pdf"
    "svg"
  ];

  meta = {
    description = "Git-like RAG (Retrieval-Augmented Generation) pipeline for local files";
    homepage = "https://github.com/baehyunsol/ragit";
    changelog = "https://github.com/baehyunsol/ragit/tree/main/RelNotes";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ daniel-fahey ];
    mainProgram = "rag";
  };
})

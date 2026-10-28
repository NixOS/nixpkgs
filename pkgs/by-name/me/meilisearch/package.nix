{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "meilisearch";
  version = "1.55.0";

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "meilisearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-k2tuArZ+/U/UGvvc70Ow8VC0+tuFgEKfc5GaAdqZDpc=";
  };

  cargoBuildFlags = [ "--package=meilisearch" ];

  cargoHash = "sha256-MZFBymNFSIVV314/BPF020R43uTRPm+Mr5w3e77WBj8=";

  # Default features include mini dashboard which downloads something from the internet.
  buildNoDefaultFeatures = true;

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  passthru = {
    updateScript = nix-update-script { extraArgs = [ "--use-github-releases" ]; };
    tests = {
      meilisearch = nixosTests.meilisearch;
    };
  };

  # Tests will try to compile with mini-dashboard features which downloads something from the internet.
  doCheck = false;

  meta = {
    description = "Powerful, fast, and an easy to use search engine";
    mainProgram = "meilisearch";
    homepage = "https://docs.meilisearch.com/";
    changelog = "https://github.com/meilisearch/meilisearch/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [
      happysalada
      bbenno
    ];
    platforms = [
      "aarch64-linux"
      "aarch64-darwin"
      "riscv64-linux"
      "x86_64-linux"
    ];
  };
})

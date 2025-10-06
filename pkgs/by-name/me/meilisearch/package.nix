{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

rustPlatform.buildRustPackage (finalAttrs: {
  pname = "meilisearch";
  version = "1.22.1";

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "meiliSearch";
    tag = "v${finalAttrs.version}";
    hash = "sha256-RWHu77/GoSMzRU7KyKmu23DFwWn6RD3MUWUc5ICY1d8=";
  };

  cargoBuildFlags = [ "--package=meilisearch" ];

  cargoHash = "sha256-xKBYumdb1vJS+UQF3yD/p+7FvWRfBKbLjOFiT7DVJ+o=";

  # Default features include mini dashboard which downloads something from the internet.
  buildNoDefaultFeatures = true;

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  passthru = {
    updateScript = nix-update-script { };
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
      "x86_64-linux"
      "x86_64-darwin"
    ];
  };
})

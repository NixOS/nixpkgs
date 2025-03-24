{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
}:

let
  version = "1.11.3";
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "meiliSearch";
    tag = "v${version}";
    hash = "sha256-CVofke9tOGeDEhRHEt6EYwT52eeAYNqlEd9zPpmXQ2U=";
  };

  cargoBuildFlags = [ "--package=meilisearch" ];

  useFetchCargoVendor = true;
  cargoHash = "sha256-cEJTokDJQuc9Le5+3ObMDNJmEhWEb+Qh0TV9xZkD9D8=";

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
    changelog = "https://github.com/meilisearch/meilisearch/releases/tag/v${version}";
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
}

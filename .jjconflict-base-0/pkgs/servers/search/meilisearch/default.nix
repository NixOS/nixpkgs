{
  stdenv,
  lib,
  rustPlatform,
  fetchFromGitHub,
  apple-sdk_11,
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
    rev = "refs/tags/v${version}";
    hash = "sha256-CVofke9tOGeDEhRHEt6EYwT52eeAYNqlEd9zPpmXQ2U=";
  };

  cargoBuildFlags = [ "--package=meilisearch" ];

  cargoLock = {
    lockFile = ./Cargo.lock;
    outputHashes = {
      "rhai-1.20.0" = "sha256-lirpciSMM+OJh6Z4Ok3nZyJSdP8SNyUG15T9QqPNjII=";
      "hf-hub-0.3.2" = "sha256-tsn76b+/HRvPnZ7cWd8SBcEdnMPtjUEIRJipOJUbz54=";
      "tokenizers-0.15.2" = "sha256-lWvCu2hDJFzK6IUBJ4yeL4eZkOA08LHEMfiKXVvkog8=";
    };
  };

  # Default features include mini dashboard which downloads something from the internet.
  buildNoDefaultFeatures = true;

  nativeBuildInputs = [ rustPlatform.bindgenHook ];

  buildInputs = lib.optional stdenv.hostPlatform.isDarwin apple-sdk_11;

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

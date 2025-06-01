{
  lib,
  rustPlatform,
  fetchFromGitHub,
  nixosTests,
  nix-update-script,
  version ? "1.14.0",
}:

let
  # Version 1.11 is kept here as it was the last version not to support dumpless
  # upgrades, meaning NixOS systems that have set up their data before 25.05
  # would not be able to update to 1.12+ without manual data migration.
  # We're planning to remove it towards NixOS 25.11. Make sure to update
  # the meilisearch module accordingly and to remove the meilisearch_1_11
  # attribute from all-packages.nix at that point too.
  hashes = {
    "1.14.0" = "sha256-nPOhiJJbZCr9PBlR6bsZ9trSn/2XCI2O+nXeYbZEQpU=";
    "1.11.3" = "sha256-CVofke9tOGeDEhRHEt6EYwT52eeAYNqlEd9zPpmXQ2U=";
  };
  cargoHashes = {
    "1.14.0" = "sha256-8fcOXAzheG9xm1v7uD3T+6oc/dD4cjtu3zzBBh2EkcE=";
    "1.11.3" = "sha256-cEJTokDJQuc9Le5+3ObMDNJmEhWEb+Qh0TV9xZkD9D8=";
  };
in
rustPlatform.buildRustPackage {
  pname = "meilisearch";
  inherit version;

  src = fetchFromGitHub {
    owner = "meilisearch";
    repo = "meiliSearch";
    tag = "v${version}";
    hash = hashes.${version};
  };

  cargoBuildFlags = [ "--package=meilisearch" ];

  useFetchCargoVendor = true;
  cargoHash = cargoHashes.${version};

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

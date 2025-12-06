{
  lib,
  fetchFromGitHub,
  rustPlatform,
  testers,
  stardust-xr-atmosphere,
  nix-update-script,
}:

rustPlatform.buildRustPackage {
  pname = "stardust-xr-atmosphere";
  version = "0.5.0-unstable-2025-11-29";

  src = fetchFromGitHub {
    owner = "stardustxr";
    repo = "atmosphere";
    rev = "b2f5b861ef91bc5d90862e2dd9ac3ff721620077";
    hash = "sha256-khvjzgePqL/d5cnaQzOrIYVQHbDKfXFP2DXx0pKGc5k=";
  };

  cargoHash = "sha256-w2qXQ6Lgea5rBVIucEbDvGZTfj9+AEziTLBFnoqgt28=";

  passthru = {
    tests.versionTest = testers.testVersion {
      package = stardust-xr-atmosphere;
      command = "atmosphere --version";
      version = "stardust-xr-atmosphere 0.4.0";
    };
    updateScript = nix-update-script {
      extraArgs = [ "--version=branch" ];
    };
  };

  meta = {
    description = "Environment, homespace, and setup client for Stardust XR";
    homepage = "https://stardustxr.org";
    license = lib.licenses.mit;
    mainProgram = "atmosphere";
    maintainers = with lib.maintainers; [
      pandapip1
      technobaboo
    ];
    platforms = lib.platforms.linux;
  };
}

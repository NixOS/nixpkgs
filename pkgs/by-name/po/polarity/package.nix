{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-04-06";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "3d661ea0485a83b0c1065595839cb2d9d594e4e8";
    hash = "sha256-4NeDOGzCq211SVVtfISq/Z901Et1zYhMQ/t7eNEBW9Y=";
  };

  useFetchCargoVendor = true;
  cargoHash = "sha256-S0d64jFKiyGVIFH8HhT4mzBEVUPDIMevvClTeqy0/28=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "A Language with Dependent Data and Codata Types";
    homepage = "https://polarity-lang.github.io/";
    changelog = "https://github.com/polarity-lang/polarity/blob/${src.rev}/CHANGELOG.md";
    license = with lib.licenses; [
      mit
      asl20
    ];
    maintainers = [ lib.maintainers.mangoiv ];
    mainProgram = "pol";
    platforms = lib.platforms.all;
  };
}

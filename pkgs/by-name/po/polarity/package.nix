{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-09-25";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "e582716daae20d534f7c7ecc58569bfd28d679f2";
    hash = "sha256-L9eBD8rA8cBdd2FFeyFKSl8/lse1OlgogEOTkVYkxHo=";
  };

  cargoHash = "sha256-EB6DlhD+0oneAGhLHi3bWnnFUIfNdKeW52umWHZEP7c=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Language with Dependent Data and Codata Types";
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

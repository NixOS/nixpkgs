{
  lib,
  fetchFromGitHub,
  rustPlatform,
  nix-update-script,
}:

rustPlatform.buildRustPackage rec {
  pname = "polarity";
  version = "latest-unstable-2025-10-14";

  src = fetchFromGitHub {
    owner = "polarity-lang";
    repo = "polarity";
    rev = "cd882ce79d4ebd4527f87386dba32574cefc9535";
    hash = "sha256-aRFAWIp8luAofr/5rSNYZQgjsZFeU8xvTE7RrnHRKKI=";
  };

  cargoHash = "sha256-yU+P8CqefuyDDYiaoslQ58HsXDT6iKzmNYekZwaaL3A=";

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

{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpkgs-vet";
  version = "0.0.0+multi-by-name";

  src = fetchFromGitHub {
    owner = "quantenzitrone";
    repo = "nixpkgs-vet";
    rev = "bafbeff7510eb66dc5dc925afe82190d76dd8cfe";
    hash = "sha256-TouxmNnE8kGldOq9tUJlwROW7SxKlWTZ/aG+GDynWSM=";
  };

  cargoHash = "sha256-RVZ3HgTkDmu+lbrNxGw4oQIatJE3Td23bI71+Y8cUrw=";

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to vet (check) Nixpkgs, including its pkgs/by-name directory";
    changelog = "https://github.com/NixOS/nixpkgs-vet/blob/${finalAttrs.src.rev}/CHANGELOG.md";
    homepage = "https://github.com/NixOS/nixpkgs-vet";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-vet";
    maintainers = with lib.maintainers; [
      mdaniels5757
      philiptaron
      willbush
    ];
    teams = [ lib.teams.ci ];
  };
})

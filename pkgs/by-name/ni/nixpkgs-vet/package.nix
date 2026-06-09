{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpkgs-vet";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-vet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-GJhN77zLtV2fUEL5wxjcybtDqUa6ODg39d3UxuOrapo=";
  };

  cargoHash = "sha256-zTh18jec0trJP4q3rYheHZz01lbkhpDaotuPbvgzMpo=";

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
  };
})

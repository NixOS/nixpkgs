{
  fetchFromGitHub,
  lib,
  nix,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpkgs-vet";
  version = "0.3.0";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-vet";
    tag = finalAttrs.version;
    hash = "sha256-Rk1p6qAqAtl5bwg9dNZ0yc4m1yOOxybWvTwfuNcOkFQ=";
  };

  cargoHash = "sha256-GaQ2ldsGabsDMx1bHuZwnSvtPp1LgPkj2C07cnEBdDY=";

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to vet (check) Nixpkgs, including its pkgs/by-name directory";
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

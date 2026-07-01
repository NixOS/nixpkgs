{
  fetchFromGitHub,
  lib,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpkgs-vet";
  version = "0.3.3";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-vet";
    tag = "v${finalAttrs.version}";
    hash = "sha256-vOKZ5Da6PMI39WlOS7CXDME3oCvJw64dQDEfaCsDL0A=";
  };

  cargoHash = "sha256-9XQvmYO4bw57NoKsXTY281fMQE0vjV3pvoRlrUaRX3o=";

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

{
  fetchFromGitHub,
  lib,
  nix,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpkgs-vet";
  version = "0.1.4";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-vet";
    tag = finalAttrs.version;
    hash = "sha256-J61eOTeDMHt9f1XmKVrEMAFUgwHGmMxDoSyY3v72QVY=";
  };

  cargoHash = "sha256-H2JAIMJeVqp8xq75eLEBKiK2pBrgC7vgXXlqbrSUifE=";

  doCheck = false;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Tool to vet (check) Nixpkgs, including its pkgs/by-name directory";
    homepage = "https://github.com/NixOS/nixpkgs-vet";
    license = lib.licenses.mit;
    mainProgram = "nixpkgs-vet";
    maintainers = with lib.maintainers; [
      philiptaron
      willbush
    ];
  };
})

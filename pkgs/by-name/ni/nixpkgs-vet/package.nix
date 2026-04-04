{
  fetchFromGitHub,
  lib,
  nix,
  nix-update-script,
  rustPlatform,
}:
rustPlatform.buildRustPackage (finalAttrs: {
  pname = "nixpkgs-vet";
  version = "0.2.0";

  src = fetchFromGitHub {
    owner = "NixOS";
    repo = "nixpkgs-vet";
    tag = finalAttrs.version;
    hash = "sha256-TxQkD9jPoONec87qGXOIQNh+lZ7kyFM6q1RtlgxEqy4=";
  };

  cargoHash = "sha256-Wx8AwgUENVbxv9GgB/DTH5aGIRznAslABjxRu/X0l2s=";

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

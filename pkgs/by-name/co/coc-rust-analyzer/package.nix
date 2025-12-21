{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2025-12-15";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "493f10d0537e82d49eb13aba5f9bc4973f92ed2c";
    hash = "sha256-MmoI4Bu883PNi6t6MBmMbEd+OTcN/dfOfsbJi2EsnzM=";
  };

  npmDepsHash = "sha256-Qksi1G4YeFU94mIccyMpphER9d/UiCOriqbe0w7LA6c=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2025-12-23";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "e64fabb840a35ad1feeedc88b181dd8593c88d8b";
    hash = "sha256-npAMi7652BUG4coQjkLIcWcSQ4kH+aDwZXsPsLCeZdY=";
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

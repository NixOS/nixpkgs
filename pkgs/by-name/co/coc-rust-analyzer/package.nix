{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-01-20";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "edde4d30f76bb6ff2e0684be4da496ed5d8166c4";
    hash = "sha256-cBpGhkpqAnzjUHyzuTWkUxMpFjGIdxrXu7TZRbomK9A=";
  };

  npmDepsHash = "sha256-PgMgpVoKmhuqtSV73wSdqdQ5Bt5AeRwbn71mIulBh8Y=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "ffb3c8af18c7c86e05f335d2a614d1a88bd61a3e";
    hash = "sha256-8d4GCWpVSwlGn2HSB56/Nll4U+YPx4aupRBxkOUUAr8=";
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

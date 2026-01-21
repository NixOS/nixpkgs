{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-01-06";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "35615c7feafbc8005e160e7609888a97f5d3b031";
    hash = "sha256-Kj3gUKFsfgUVVWuz7nuc7djRvfyvXc3wkHt1DxYIw30=";
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

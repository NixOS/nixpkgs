{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2025-12-02";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "8f9ac44c8154b26f993e0e0ad4c5c55918f3661e";
    hash = "sha256-pmvgF5mHh8djzKFLlcRVOZjZ5e5kN1ymqthYuPPYgmA=";
  };

  npmDepsHash = "sha256-WOwCgsynYeINS39Lhahd++1qJwcFRUv0kENRO13mKio=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}

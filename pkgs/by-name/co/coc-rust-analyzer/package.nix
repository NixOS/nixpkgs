{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-07-14";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "4e0c84fdbfb8252cc88d0d8ef8af6642a00b8abc";
    hash = "sha256-XTerfjqPyyFlt4y1g1LlAN/JV0aXWEbwCb03YqkMySM=";
  };

  npmDepsHash = "sha256-ifDAM08pfdbqPl9G5s5cx8hGzldNuVc0DcXDyCGgkkI=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

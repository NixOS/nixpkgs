{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-rust-analyzer";
  version = "0-unstable-2026-05-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-rust-analyzer";
    rev = "9bfd30f3ab029c31f1c012b12156bdac9a0d0351";
    hash = "sha256-JrR7nf6xQxzGHrOp1dof6GLOcH6BSiAd79RcgsUUU24=";
  };

  npmDepsHash = "sha256-1+U4XG3zciSnVh8Syff/hZgSPBdwDfgf9KQFURJAddQ=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Rust-analyzer extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-rust-analyzer";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

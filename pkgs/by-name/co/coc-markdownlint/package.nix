{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2025-12-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "5a3b292e791e7d33bacac8e9e952aef3aab9f867";
    hash = "sha256-EaJjeaR8cfqGy2I7nLxPlNyiq4ERpWqUF9i/LloOJaQ=";
  };

  npmDepsHash = "sha256-DCHrO+cuSepnBHl4miLivFElSmSbgH/NRQH68zSJAVA=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}

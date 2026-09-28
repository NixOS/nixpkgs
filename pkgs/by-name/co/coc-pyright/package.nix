{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2026-09-10";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "c68d7536585370c0b4c71745f73c0aec143adfbd";
    hash = "sha256-r3tyONShlHQD7SLRDM/afTVqpKghozQBzT+oEgtA8JU=";
  };

  npmDepsHash = "sha256-9fFi23Y1IfzAvxzxDBpbTJmzQNyVioL+lEbq96LRhks=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "e2b57a6f9ff7f0fef95a77e8bfa0a8dff442a5ed";
    hash = "sha256-VoDRDhLA922jDDRyj2Vi/wTNA5waDpHXW1O+sO0xlaI=";
  };

  npmDepsHash = "sha256-oJtTE05/A8JEgqtcXvS++Lmw2wJu5+4b0457usg4y3g=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

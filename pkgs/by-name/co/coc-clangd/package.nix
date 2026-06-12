{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2026-06-13";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "45d66ce2ed6caf5f5ced672d6b45a41e90dd623f";
    hash = "sha256-QmC8USEHBzuC2NcVjjAsPXpg9ClW28+E+cadNhdXLg0=";
  };

  npmDepsHash = "sha256-2tpijK2jAPZNrS2h5beUgEsPE2UXAodvE496K2kKz3w=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = [ ];
    hasNoMaintainersButDependents = true;
  };
}

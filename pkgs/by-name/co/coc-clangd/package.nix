{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2026-05-01";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "1a9f68c7266621fd8cb5aa5863ec63927232fbfc";
    hash = "sha256-FhJzJAf5jcdYCpPAKlJUNcVb0U8mkAiS5MoCTQpj/mM=";
  };

  npmDepsHash = "sha256-jPgvi+Wz39d56d0YQSF99HqZ3rYi97kfGv7r0IY5WbY=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

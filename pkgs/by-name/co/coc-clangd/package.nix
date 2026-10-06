{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "9b6774c41c695ff0f937d88d07e9446d5c76b4c8";
    hash = "sha256-gkd62ny0DtKjwhNVLYZoDGqKz8o6/5LeJtikPpr4Ejo=";
  };

  npmDepsHash = "sha256-cjwTbuoFtKcH7xp1UtOU3B4VSH6CVnycIaXD1PbQVFg=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

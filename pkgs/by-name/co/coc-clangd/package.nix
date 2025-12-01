{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2025-11-18";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "72a4edc5ec39c6d7c4fd5a49aee7d9f3f84b8b6e";
    hash = "sha256-uNCN3+8KovQ/Grrv7k5YZz6tTCNUX+6EN1Gkm867LMc=";
  };

  npmDepsHash = "sha256-cLW5pY3LaumtE2qyxMMP9WirCMdWq+gsSO+dZNhCc1g=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}

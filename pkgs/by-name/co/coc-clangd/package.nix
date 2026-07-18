{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2026-07-01";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "d745e149736451664ab448d08f3e9f83ec3cc70d";
    hash = "sha256-juqZg1zsmQYdokvH83InUP1YpS8oybPhglapMas5z0A=";
  };

  npmDepsHash = "sha256-OgNHgDSAqINNmskwhrWNh+TiHGRE4Y9SCFc0+RTs+CI=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

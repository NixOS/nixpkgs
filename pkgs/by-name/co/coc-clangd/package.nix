{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2026-04-01";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "34d9ed8e7a08f29e398720802401455733e6a481";
    hash = "sha256-PiPH9kXmVdu9Ul0t28E1jumZILX7IwIr2OBDfCepobs=";
  };

  npmDepsHash = "sha256-QVsNztjTuHU0vu53IxjfFqllj1JxHnLwT9B9jaUnWIo=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

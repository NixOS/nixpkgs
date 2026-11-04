{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2026-11-01";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "0979607a8a166c8654033f9a6e10790a63286039";
    hash = "sha256-JTg04IYwFORJjb953rO5muyH0+sNIFIQAjPGSIieojs=";
  };

  npmDepsHash = "sha256-3JmK+u9hjBnB3VrLaw+SQmAr/3qtap4EXYtwmRaTl2A=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

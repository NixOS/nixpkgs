{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-clangd";
  version = "0-unstable-2026-06-02";

  src = fetchFromGitHub {
    owner = "clangd";
    repo = "coc-clangd";
    rev = "93926afd0beb4ac9beabddbac8b14743e2762fa9";
    hash = "sha256-03VgcaJ+EZmRXxKcWaHO9kVb9dmIGI30CiJNDkjp3CY=";
  };

  npmDepsHash = "sha256-YoFfBQjWvJZ1Xj9dkNmtb7jZI43eFf9O/WZDwOBejdo=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "clangd extension for coc.nvim";
    homepage = "https://github.com/clangd/coc-clangd";
    license = lib.licenses.asl20;
    maintainers = [ ];
  };
}

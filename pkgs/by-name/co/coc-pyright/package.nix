{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2026-09-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "ec3606372c6e8a8528b9c5304e5716f0a269e25a";
    hash = "sha256-/75ZdYLgnv9o3qLYnHfrBnU2kwvkQvURo0BM9BIJWbs=";
  };

  npmDepsHash = "sha256-2vpH0Qvq3lLEIWf/2razIRUE7vMB5Zbzo105qSGnmxE=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

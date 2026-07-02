{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2026-02-10";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "4bcc312b40fecbf7cad50d7c75579a1eedae337b";
    hash = "sha256-rh3d3IlX9EKxJamJ1ldbsjOQ4n6+WLt+Lgh24sQfRBQ=";
  };

  npmDepsHash = "sha256-e7S8TS+ZvTGmTYChgYhicoHoESIT4fjkby1FO9D/ZNY=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

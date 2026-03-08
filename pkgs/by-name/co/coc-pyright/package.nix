{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2026-03-03";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "315bf413533e32cbeef488654360a0b8359b1044";
    hash = "sha256-5iswb+M/N2zeCkWB6e9PsFB6KfxsOxAFV5+2vzuCWt4=";
  };

  npmDepsHash = "sha256-iTW7A+pG4w3N0dmLgd2+xsQhlDUZwscoF+awS+K1pOM=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

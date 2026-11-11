{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2026-11-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "692b1e88b6df9de2ee033618414ddc72f3e6855d";
    hash = "sha256-rquFuEOK4/zx4iAqgVLUcYpnO8GSVr0JJme+I69IRv4=";
  };

  npmDepsHash = "sha256-bProL/Mu0D7Pih75Mlko2B+o0RtImVIjd8yWJukOeTs=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2026-10-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "3217920ae44add2cafeb9d270dfc06ca0e733747";
    hash = "sha256-tgyzss+ErtsUSIVuIaBAzQhmzmC+nw3EqYDPFxRT538=";
  };

  npmDepsHash = "sha256-fzjCMC6EDEMZRgh/scfIaTUDil/y8UoJP6QdhQM+mk8=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

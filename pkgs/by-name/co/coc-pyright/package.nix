{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2026-01-04";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "767eebcb9f9b828412b9ec02e80558f3e748798a";
    hash = "sha256-PNCh6EiXQxIYgU6hOG1/ialhP0p2uGTQAgipiDpgI6s=";
  };

  npmDepsHash = "sha256-D5e17ubJ8leB5zoNO0DbZ1rUf/JpSJlezOldA3pvtFo=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}

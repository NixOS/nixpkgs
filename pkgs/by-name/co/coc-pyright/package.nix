{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-pyright";
  version = "0-unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-pyright";
    # No tagged releases, this commit corresponds to the latest release of the package.
    rev = "33184c03e543b29227df989cf893752bae5f3ea2";
    hash = "sha256-fj6iSQHprf/lkDGI5aFsogMAPv6a3Ghp9uDqnTM3/MY=";
  };

  npmDepsHash = "sha256-0KKEPl0H0HxNCw7GTaxE+voQhS5J1TSpd4JjyWW62UI=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Pyright extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-pyright";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}

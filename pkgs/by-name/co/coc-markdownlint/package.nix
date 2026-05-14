{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2026-05-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "91345f973c7fde3e72f95bc7648043c35e23e007";
    hash = "sha256-Uj+PKaihRaWybWvt82Aenmt1/seTsJwgb4LSF+gIAc0=";
  };

  npmDepsHash = "sha256-J5LHaKrtQeYiIU06rargZrQX5P4ABP0cP0wuPHIRzjw=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}

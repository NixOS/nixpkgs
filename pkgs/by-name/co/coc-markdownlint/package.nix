{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2026-01-01";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "40ed0685b2849e77bc8769e3ab1171ced542c5e3";
    hash = "sha256-rHFkypWQKjfHGeiij2DMldAKXVjghkxB/5mGIjIpS9k=";
  };

  npmDepsHash = "sha256-8ex8JdtSREFl59cT5Mu/PtmjyjMG7PU7IJ31wStp+8I=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ pyrox0 ];
  };
}

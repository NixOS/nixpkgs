{
  lib,
  buildNpmPackage,
  fetchFromGitHub,
  nix-update-script,
}:

buildNpmPackage {
  pname = "coc-markdownlint";
  version = "0-unstable-2026-11-02";

  src = fetchFromGitHub {
    owner = "fannheyward";
    repo = "coc-markdownlint";
    rev = "0425357a8012396abcf996d0c606b86ae91dd86c";
    hash = "sha256-VhQnfAo3OuV47Yc1tdfy2w3j+nH05y1xIOGslHcgUVw=";
  };

  npmDepsHash = "sha256-grJxBMMTAQSxvLkqKoyKPVvjEDaQjybWNW0CICfN5cY=";

  passthru.updateScript = nix-update-script { extraArgs = [ "--version=branch" ]; };

  meta = {
    description = "Markdownlint extension for coc.nvim";
    homepage = "https://github.com/fannheyward/coc-markdownlint";
    license = lib.licenses.mit;
    maintainers = [ ];
  };
}
